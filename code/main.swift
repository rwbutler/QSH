import Foundation
import ArgumentParser

let applicationName = "QSH"
let applicationVersion = "0.0.2"

struct QSH: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Interactive shell for playing quizzes through the macOS Terminal.",
        version: applicationVersion,
        subcommands: [PackageQuiz.self, PlayQuiz.self],
        defaultSubcommand: PlayQuiz.self
    )
}

struct PlayQuiz: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "URL which specifies where the quiz package can be found.")
    var url: URL
    
    @Option(name: .shortAndLong, help: "Key for decrypting the quiz package.")
    var key: String?
    
    func run() throws {
        let quiz = Main(quizURL: url)
        quiz.eventCallback = { event in
            switch event {
            case .message(let message):
                print("[\(applicationName)]: \(message)\n")
            case .quizComplete:
                print("\(event.description)\n")
                Self.exit(withError: nil)
            case .keyRequired, .question:
                print("\(event.description)")
                if let input = readLine() {
                    quiz.processCommand(Command(rawValue: input.trimmingCharacters(in: .whitespacesAndNewlines)))
                }
            default:
                print("\(event)\n")
            }
        }
        quiz.errorCallback = { error in
            print("\(error.localizedDescription)\n")
            if let input = readLine() {
                quiz.processCommand(Command(rawValue: input))
            }
        }
        print("---")
        print("\(applicationName)")
        print("---")
        quiz.startQuiz(key: key)
        RunLoop.main.run()
    }
}

struct PackageQuiz: ParsableCommand {
    @Flag(inversion: .prefixedNo, help: "Whether the quiz package should be encrypted to make cheating more difficult.")
    var encryptPackage: Bool
    
    @Option(name: .shortAndLong, help: "URL which specifies where the quiz JSON can be found.")
    var input: URL
    
    @Option(name: .shortAndLong, help: "Key for encrypting the quiz package.")
    var key: String
    
    // TODO: Make optional.
    @Option(name: .shortAndLong, help: "Where to output the quiz package to.")
    var output: URL
    
    func run() throws {
        let quizData = try Data(contentsOf: input)
        // TODO: Handle result.
        let result = Main.packageQuiz(jsonData: quizData, key: key, output: output)
        print(result)
    }
}

QSH.main()
