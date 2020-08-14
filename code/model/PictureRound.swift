//
//  PictureRound.swift
//  SwiftQuiz
//
//  Created by Ross Butler on 19/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

struct PictureRound: Codable {
    let id: UUID
    let answers: [String]
    let images: [Data]
    let question: String
}
