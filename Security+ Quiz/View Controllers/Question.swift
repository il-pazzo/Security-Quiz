//
//  QuizDetail.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 5/3/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

struct Question {
    
    let question: String
    let explanation: String
    let questionNumber: Int
    let isFillInTheBlank: Bool
    let hint: String
    let correctAnswers: String
    let choiceA: String
    let choiceB: String
    let choiceC: String
    let choiceD: String
    let choiceE: String
    let numChoices: Int
    let fillAnswerA: String
    let fillAnswerB: String
    let fillAnswerC: String
    let fillAnswerD: String
    let fillAnswerE: String
    let numFillAnswers: Int
}

extension Question {
    var numAnswers: Int {
        return isFillInTheBlank ? 1 : correctAnswers.count
    }
}
