//
//  ParsingService.swift
//  QSH
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//
import Foundation

protocol ParsingService {
    func parse(_ data: Data) throws -> QuizModel
}
