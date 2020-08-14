import Foundation
import ArgumentParser

struct SwiftQuiz: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Play quizzes from the CLI.",
        version: "0.0.1",
        subcommands: [PackageQuiz.self, PlayQuiz.self],
        defaultSubcommand: PlayQuiz.self
    )
}

extension URL: ExpressibleByArgument {
    public init?(argument: String) {
        self.init(string: argument)
    }
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
                print("[QSH]: \(message)\n")
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
        print("QSH")
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
        do {
            let result = Main.packageQuiz(jsonData: quizData, key: key, output: output)
            print(result)
        } catch let error {
            print(error)
        }
    }
}

SwiftQuiz.main()

struct AnyKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}

extension JSONDecoder.KeyDecodingStrategy {
    
    static let convertFromKebabCase = JSONDecoder.KeyDecodingStrategy.custom({ keys in
        guard let lastComponent = keys.last?.stringValue.split(separator: ".").last,
            lastComponent.contains("-") else {
                return keys.last ?? AnyKey(stringValue: "")! // Try to return something non-nil.
        }
        let components = lastComponent.split(separator: "-")
        var result: String
        if let firstComponent = components.first {
            let remainingComponents = components.dropFirst().map {
                $0.capitalized
            }
            result = ([String(firstComponent)] + remainingComponents).joined()
        } else {
            result = String(lastComponent)
        }
        return AnyKey(stringValue: String(result))!
    })
    
}
