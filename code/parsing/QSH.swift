//
//  QSH.swift
//  
//
//  Created by Ross Butler on 14/08/2020.
//

import Foundation
import ArgumentParser

struct QSH: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        abstract: "Interactive shell for playing quizzes through the macOS Terminal.",
        version: applicationVersion,
        subcommands: [PackageQuiz.self, PlayQuiz.self],
        defaultSubcommand: PlayQuiz.self
    )
    
}
