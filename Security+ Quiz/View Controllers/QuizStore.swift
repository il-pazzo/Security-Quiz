//
//  QuizStore.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 5/3/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

protocol QuizData {
    var quizInfo: [QuizMeta] { get }
}
class QuizStore: QuizData {
    
    static let shared = QuizStore()
    
    private init() {}

    private let quizSets: [ QuizMeta ] = [
        QuizMeta( quizTitle: "SY0-501", quizFilename: "mmsy0501_exam_1"),
        QuizMeta( quizTitle: "LX0-103", quizFilename: "LX0-103"),
        QuizMeta( quizTitle: "LX0-104", quizFilename: "LX0-104"),
        QuizMeta( quizTitle: "test2",   quizFilename: "questions_2"),
        QuizMeta( quizTitle: "test3",   quizFilename: "questions-3"),
    ]
    
    var quizInfo: [QuizMeta] { quizSets }
    
    func getQuizDetail( for title: String ) -> [Question]? {
        
        let firstMatch = quizSets.first { $0.quizTitle == title }
        guard let filename = firstMatch?.quizFilename else {
            return nil
        }

        if let jsonFilePath = Bundle.main.path(forResource: filename, ofType: "json" ) {
            if let jsonData = try? String.init(contentsOfFile: jsonFilePath ) {
                
                let json = JSON( parseJSON: jsonData )
                
                let questions = parse( json: json )
                print( "\(questions.count) questions read from \(filename)" )
            
                return questions
            }
            else {
                print( "Cannot read data from '\(filename)'" )
            }
        }
        else {
            print( "Cannot load data from '\(filename)'" )
        }

        return nil
    }
    private func parse( json: JSON ) -> [Question] {
        
        var questions = [Question]()
        
        for qa in json["questions"].arrayValue {
            
            let quizDetail = parseOneQuestion( json: qa )

            questions.append( quizDetail )
        }
        
        return questions
    }
    private func parseOneQuestion( json qa: JSON ) -> Question {
        
        let questionNumber      = qa["question_number"].intValue
        let question            = qa["question"     ].stringValue
        let hint                = qa["hint"         ].stringValue
        let explanation         = qa["explanation"  ].stringValue
        let correctAnswers      = qa["correct_answers"].stringValue
        
        let choices             = qa["choices"      ].arrayValue.map({ $0.stringValue })
        let choiceA             = choices.count > 0 ? choices[0] : ""
        let choiceB             = choices.count > 1 ? choices[1] : ""
        let choiceC             = choices.count > 2 ? choices[2] : ""
        let choiceD             = choices.count > 3 ? choices[3] : ""
        let choiceE             = choices.count > 4 ? choices[4] : ""
        
        let fillAnswers         = qa["fill_answers" ].arrayValue.map({ $0.stringValue })
        let fillAnswerA         = fillAnswers.count > 0 ? fillAnswers[0] : ""
        let fillAnswerB         = fillAnswers.count > 1 ? fillAnswers[1] : ""
        let fillAnswerC         = fillAnswers.count > 2 ? fillAnswers[2] : ""
        let fillAnswerD         = fillAnswers.count > 3 ? fillAnswers[3] : ""
        let fillAnswerE         = fillAnswers.count > 4 ? fillAnswers[4] : ""
        
        let isFillInTheBlank    = qa["is_fill_in_the_blank"].bool ?? false

        let quizDetail = Question(question: question,
                                  explanation: explanation,
                                  questionNumber: questionNumber,
                                  isFillInTheBlank: isFillInTheBlank,
                                  hint: hint,
                                  correctAnswers: correctAnswers,
                                  choiceA: choiceA,
                                  choiceB: choiceB,
                                  choiceC: choiceC,
                                  choiceD: choiceD,
                                  choiceE: choiceE,
                                  numChoices: choices.count,
                                  fillAnswerA: fillAnswerA,
                                  fillAnswerB: fillAnswerB,
                                  fillAnswerC: fillAnswerC,
                                  fillAnswerD: fillAnswerD,
                                  fillAnswerE: fillAnswerE,
                                  numFillAnswers: fillAnswers.count)
        
        return quizDetail
    }
}
