//
//  QuizStore.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 5/3/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

protocol QuizData {
    var quizInfo: [QuizInfo] { get }
}
class QuizStore: QuizData {

    private let quizSets: [ QuizInfo ] = [
        QuizInfo( quizTitle: "SY0-501", quizFilename: "mmsy0501_exam_1"),
        QuizInfo( quizTitle: "LX0-103", quizFilename: "LX0-103"),
        QuizInfo( quizTitle: "LX0-104", quizFilename: "LX0-104"),
        QuizInfo( quizTitle: "test2",   quizFilename: "questions_2"),
        QuizInfo( quizTitle: "test3",   quizFilename: "questions-3"),
    ]
    
    var quizInfo: [QuizInfo] { quizSets }
}
