//
//  Services.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//
import Foundation

struct Services {
    
    static var images: ImagesService {
        return CommandLineImagesService()
    }
    
    static var parsing: ParsingService {
        return CodableParsingService()
    }
    
    static func accessControl(_ quiz: Quiz) -> AccessControlService {
        return DefaultAccessControlService(quiz: quiz)
    }
    
}
