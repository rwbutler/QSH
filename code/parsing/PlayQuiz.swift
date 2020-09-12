//
//  PlayQuiz.swift
//  
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation
import ArgumentParser
import SwiftQuiz

struct PlayQuiz: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "URL which specifies where the quiz package can be found.")
    var url: URL
    
    @Option(name: .shortAndLong, help: "Key for decrypting the quiz package.")
    var key: String?
    
    func run() throws {
        let quiz = SwiftQuiz(url: url)
        quiz.eventCallbacks.append({ event in
            switch event {
            case .message(let message):
                print("[\(applicationName)]: \(message)\n")
            case .quizComplete:
                print("\(event.description)\n")
                Self.exit(withError: nil)
            case .question(let question):
                print("\(question.description)")
                if let input = readLine() {
                    quiz.processCommand(Command(rawValue: input.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            case .keyRequired:
                print("\(event.description)")
                if let input = readLine() {
                    quiz.processCommand(Command(rawValue: input.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            default:
                print("\(event)\n")
            }
        })
        quiz.errorCallbacks.append({ error in
            print("\(error.localizedDescription)\n")
            if let input = readLine() {
                quiz.processCommand(Command(rawValue: input))
            }
        })
        print("---")
        print("\(applicationName)")
        print("---")
        quiz.startQuiz(key: key)
        RunLoop.main.run()
    }
}
