//
//  Trivia.swift
//  TrueFalseStarter
//
//  Created by MacBook Air on 3/20/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation
import UIKit


struct Trivia {
    var question: String
    var correctA: String
    var wrong1: String
    var wrong2: String
    var wrong3: String
}

struct Quiz {
        let question: String
        let answers: [String]
        let correctAnswer: Int
    }
