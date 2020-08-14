//
//  QuizModel.swift
//  QSH
//
//  Created by Ross Butler on 18/07/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation

struct QuizModel: Codable {
    let flagPole: URL?
    let title: String
    let marking: Marking?
    let markingUrl: URL?
    let rounds: [RoundModel]
}
