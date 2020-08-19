//
//  QuizServicesAdditions.swift
//  
//
//  Created by Ross Butler on 17/08/2020.
//

import Foundation
import SwiftQuiz

extension QuizServices {
    
    static var images: ImagesService {
        return CommandLineImagesService()
    }
    
}
