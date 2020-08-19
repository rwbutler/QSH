//
//  PackageQuiz.swift
//  
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation
import ArgumentParser
import SwiftQuiz

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
        let result = SwiftQuiz.packageQuiz(jsonData: quizData, key: key, output: output)
        print(result)
    }
    
}
