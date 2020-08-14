//
//  SwiftQuiz.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation
import Hash

public enum Command: RawRepresentable {
    
    public typealias RawValue = String
    
    case answer
    case nextQuestion
    case nextRound
    case start
    case question
    case round
    case unknown(_ argument: String)
    
    public init(rawValue: String) {
        switch rawValue {
        case "answer":
            self = .answer
        case "question":
            self = .question
        case "round":
            self = .round
        case "next-question":
            self = .nextQuestion
        case "next-round":
            self = .nextRound
        case "start":
            self = .start
        default:
            self = .unknown(rawValue)
        }
    }
    
    public var rawValue: String {
        switch self {
        case .answer:
            return "answer"
        case .question:
            return "question"
        case .nextQuestion:
            return "next-question"
        case .nextRound:
            return "next-round"
        case .round:
            return "round"
        case .unknown(let answer):
            return answer
        case .start:
            return "start"
        }
    }
}

public class Main {
    
    public typealias PackageQuizResult = Result<Void, Error>
    public typealias QuizResult = Result<Quiz, Error>
    typealias QuestionKey = UUID
    
    private var answers: [QuestionKey: [String]] = [:]
    private var currentQuestion: Question?
    private var currentRound: Round?
    private let queue = OperationQueue()
    private var previousOperation: Operation?
    private let externalQueue: DispatchQueue = DispatchQueue.global(qos: .userInteractive)
    private let internalQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    private var player: String?
    private var quiz: Quiz?
    private var quizData: Data?
    private let quizURL: URL
    private var accessControlService: AccessControlService?
    
    public var advanceAutomatically: Bool = true
    public var eventCallback: ((QuizEvent) -> Void)?
    public var errorCallback: ((Error) -> Void)?
    
    init(quizURL: URL) {
        self.quizURL = quizURL
    }
    
    public func nextQuestion() {
        switch (currentRound, currentQuestion) {
        case (.none, .none), (.none, .some(_)):
            if advanceAutomatically {
                startQuiz()
            }
        case (.some(let round), .none):
            guard let firstQuestion = round.questions.first else {
                invokeCallback(with: QuizError.emptyRound)
                return
            }
            currentQuestion = firstQuestion
            invokeCallback(with: .question(firstQuestion.question))
            if let image = firstQuestion.image {
                Services.images.showImage(questionId: firstQuestion.id, image: image)
            }
        case (.some(let round), .some(let question)):
            guard let questionIndex = round.questions.firstIndex(where: { roundQuestion in
                roundQuestion == question
            }) else {
                return
            }
            let nextQuestionIndex = questionIndex.advanced(by: 1)
            guard nextQuestionIndex != round.questions.endIndex else {
                if advanceAutomatically {
                    nextRound()
                }
                return
            }
            guard let nextQuestion = currentRound?.questions[nextQuestionIndex] else {
                invokeCallback(with: QuizError.internalError)
                return
            }
            setQuestion(nextQuestion)
        }
    }
    
    private func setQuestion(_ question: Question) {
        accessControlService?.isUnlocked(question.id) { [weak self] isUnlocked in
            guard let self = self else {
                return
            }
            guard isUnlocked else {
                self.invokeCallback(with: .waitingForNextQuestion)
                return
            }
            self.currentQuestion = question
            self.invokeCallback(with: .question(question.question))
            if let image = question.image {
                Services.images.showImage(questionId: question.id, image: image)
            }
        }
    }
    
    private func setRound(_ round: Round) {
        accessControlService?.isUnlocked(round.id) { [weak self] isUnlocked in
            guard let self = self else {
                return
            }
            guard isUnlocked else {
                self.invokeCallback(with: .waitingForNextRound)
                return
            }
            self.currentRound = round
            self.currentQuestion = nil
            self.invokeCallback(with: .roundStart(round.title))
            if self.advanceAutomatically {
                self.nextQuestion()
            }
        }
    }
    
    public func nextRound() {
        guard let quiz = self.quiz else {
            downloadQuiz(quizURL: quizURL)
            return
        }
        guard let currentRound = self.currentRound else {
            invokeCallback(with: QuizError.noContent)
            return
        }
        guard let roundIndex = quiz.rounds.firstIndex(where: { round in
            round == currentRound
        }) else {
            return
        }
        let nextRoundIndex = roundIndex.advanced(by: 1)
        guard nextRoundIndex != quiz.rounds.endIndex else {
            let rounds: [MarkingSubmissionRound] = quiz.rounds.map { round in
                let answers = round.questions.map { question in
                    return MarkingSubmissionAnswer(question: question.question, answer: self.answers[question.id] ?? [])
                }
                return MarkingSubmissionRound(title: round.title, answers: answers)
            }
            let submission = MarkingSubmission(submission: rounds)
            let answersURL = URL(fileURLWithPath: "answers.txt")
            try? submission.description.data(using: .utf8)?.write(to: answersURL)
            if let slackURL = quiz.configuration.markingURL {
                let messagingService = SlackMessagingService(hookURL: slackURL)
                messagingService.message(submission.description) {
                    self.invokeCallback(with: .quizComplete)
                }
            } else {
                invokeCallback(with: .quizComplete)
            }
            return
        }
        let nextRound = quiz.rounds[nextRoundIndex]
        setRound(nextRound)
    }
    
    /// Note: This method is synchronous.
    public static func packageQuiz(jsonData: Data, key: String?, output: URL) -> PackageQuizResult {
        let parsingService = Services.parsing
        do {
            let model = try parsingService.parse(jsonData)
            let factory = QuizFactory(model: model)
            let quiz = try factory.manufacture()
            let encoder = JSONEncoder()
            var outputData = try encoder.encode(quiz)
            if let key = key?.data(using: .utf8) {
                outputData = EncryptedData(message: outputData, key: key, algorithm: .aes256).data()
            }
            try outputData.write(to: output)
            return .success(())
        } catch let error {
            return .failure(error)
        }
    }
    
    /// Invoke this method after receiving the `quizReady` event.
    public func startQuiz(key: String? = nil) {
        guard let quiz = self.quiz else {
            downloadQuiz(quizURL: quizURL, key: key)
            return
        }
        guard let firstRound = quiz.rounds.first else {
            invokeCallback(with: QuizError.noContent)
            return
        }
        currentRound = firstRound
        currentQuestion = nil
        invokeCallback(with: .roundStart(firstRound.title))
        if advanceAutomatically {
            nextQuestion()
        }
    }
    
    public func processCommand(_ command: Command) {
        switch command {
        case .answer:
            guard let currentQuestion = self.currentQuestion else {
                invokeCallback(with: .message("No question in progress"))
                return
            }
            if let answer = answers[currentQuestion.id] {
                invokeCallback(with: .message("Submitted answer: \(answer)"))
            } else {
                invokeCallback(with: .message("No answer submitted"))
            }
        case .nextQuestion:
            nextQuestion()
        case .nextRound:
            nextRound()
        case .question:
            if let question = currentQuestion {
                invokeCallback(with: .message("Question: \(question.question)"))
            } else {
                invokeCallback(with: .message("No question in progress"))
            }
        case .round:
            if let roundTitle = currentRound?.title {
                invokeCallback(with: .message("Round: \(roundTitle)"))
            } else {
                invokeCallback(with: .message("Round not yet started"))
            }
        case .start:
            startQuiz()
        case .unknown(let input):
            if let quizData = self.quizData, quiz == nil { // Quiz is nil, assume not unpacked due to decryption failure.
                unpackQuiz(quizData: quizData, key: input)
            } else {
                invokeCallback(with: .message("Submitted answer: \(input)"))
                submitAnswer(input)
            }
        }
    }
    
    public func submitAnswer(_ answer: String?) {
        guard let currentQuestion = self.currentQuestion else {
            return
        }
        let submittedAnswers: [String]?
        if let answer = answer {
            submittedAnswers = [answer]
        } else {
             submittedAnswers = nil
        }
        answers[currentQuestion.id] = submittedAnswers
        if advanceAutomatically {
            nextQuestion()
        }
    }
    
    public static func unpackageQuiz(url: URL, key: String?, completion: @escaping(QuizResult) -> Void) {
        do {
            var inputData = try Data(contentsOf: url)
            if let key = key?.data(using: .utf8) {
                inputData = DecryptedData(message: inputData, key: key, algorithm: .aes256).data()
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromKebabCase
            let quiz = try decoder.decode(Quiz.self, from: inputData)
            completion(.success(quiz))
        } catch let error {
            completion(.failure(error))
        }
    }
    
}

private extension Main {
    
    private func attemptQuizUnpack(quizData: Data) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromKebabCase
            let quiz = try decoder.decode(Quiz.self, from: quizData)
            self.quiz = quiz
            self.accessControlService = Services.accessControl(quiz)
            invokeCallback(with: .quizReady)
            if advanceAutomatically {
                startQuiz(key: nil)
            }
        } catch _ {
            invokeCallback(with: .keyRequired)
        }
    }
    
    private func unpackQuiz(quizData: Data, key: String) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromKebabCase
            guard let keyData = key.trimmingCharacters(in: .whitespacesAndNewlines).data(using: .utf8) else {
                return
            }
            let plainTextData = DecryptedData(message: quizData, key: keyData, algorithm: .aes256).data()
            let quiz = try decoder.decode(Quiz.self, from: plainTextData)
            self.quiz = quiz
            self.accessControlService = Services.accessControl(quiz)
            invokeCallback(with: .quizReady)
            if advanceAutomatically {
                startQuiz(key: key)
            }
        } catch let error {
            invokeCallback(with: error)
        }
    }
    
    private func downloadQuiz(quizURL: URL, key: String? = nil) {
        internalQueue.async { [weak self] in
            do {
                self?.quizData = try Data(contentsOf: quizURL)
                if let quizData = self?.quizData {
                    if let key = key {
                        self?.unpackQuiz(quizData: quizData, key: key)
                    } else {
                        self?.attemptQuizUnpack(quizData: quizData)
                    }
                }
            } catch let error {
                self?.invokeCallback(with: error)
            }
        }
    }
    
    private func invokeCallback(with event: QuizEvent) {
        let nextOperation = BlockOperation { [weak self] in
            self?.eventCallback?(event)
        }
        if let previousOperation = previousOperation {
            nextOperation.addDependency(previousOperation)
        }
        queue.addOperation(nextOperation)
        previousOperation = nextOperation
    }
    
    private func invokeCallback(with error: Error) {
        externalQueue.async { [weak self] in
            self?.errorCallback?(error)
        }
    }
    
}

struct QuizFactory {
    
    private let model: QuizModel
    
    init(model: QuizModel) {
        self.model = model
    }
    
    private func imageDataSync(url: URL?) throws -> Data? {
        guard let url = url else {
            return nil
        }
        return try Data(contentsOf: url)
    }
    
    func manufacture() throws -> Quiz {
        let rounds: [Round] = try model.rounds.map { roundModel in
            let questions: [Question] = try roundModel.questions.map { questionModel in
                switch questionModel.type {
                case "short-answer":
                    guard let answer = questionModel.answer else {
                        throw PackagingError.questionMissingAnswer
                    }
                    let shortAnswer = ShortAnswer(
                        id: UUID(),
                        answer: answer,
                        image: try imageDataSync(url: questionModel.image),
                        question: questionModel.question
                    )
                    return .shortAnswer(shortAnswer)
                case "multiple-choice":
                    guard let answer = questionModel.answer,
                        let choices = questionModel.choices else {
                            throw PackagingError.multipleChoiceQuestionMissingChoices
                    }
                    let multipleChoice = MultipleChoice(
                        id: UUID(),
                        answer: answer,
                        choices: choices,
                        image: try imageDataSync(url: questionModel.image),
                        question: questionModel.question
                    )
                    return .multipleChoice(multipleChoice)
                case "multiple-answer":
                    guard let answers = questionModel.answers else {
                        throw PackagingError.questionMissingAnswer
                    }
                    let scoring = questionModel.scoring ?? [QuestionScoring(answerCount: nil, awardsScore: 1, awardedFor: .allCorrect)]
                    let multipleAnswer = MultipleAnswer(
                        id: UUID(),
                        answers: answers,
                        image: try imageDataSync(url: questionModel.image),
                        question: questionModel.question,
                        scoring: scoring
                    )
                    return .multipleAnswer(multipleAnswer)
                case "picture-round":
                    let imageData = try questionModel.images?.compactMap {
                        return try imageDataSync(url: $0)
                    }
                    guard let answers = questionModel.answers,
                        let images = imageData else {
                            throw PackagingError.pictureRoundMissingImages
                    }
                    let pictureRound = PictureRound(
                        id: UUID(),
                        answers: answers,
                        images: images,
                        question: questionModel.question
                    )
                    return .pictureRound(pictureRound)
                default:
                    throw PackagingError.invalidQuestionType
                }
            }
            return Round(id: UUID(), title: roundModel.name, questions: questions)
        }
        let quizType: QuizType
        if let flagPoleURL = model.flagPole {
            quizType = .remote(flagPole: flagPoleURL)
        } else {
            quizType = .local
        }
        let configuration = QuizConfiguration(
            marking: model.marking ?? .none,
            markingURL: model.markingUrl,
            type: quizType
        )
        return Quiz(configuration: configuration, rounds: rounds)
    }
    
}
