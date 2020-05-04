//
//  Quiz.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 5/3/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

enum BoolString: String
{
    case YES = "Y"
    case NO = "N"
}

struct Quiz {
    var questions: [Question]?
    
    var numQuestions: Int { questions?.count ?? 0 }
    
    mutating func loadQuestions( for title: String ) {
        
        questions = QuizStore.shared.quizDetail(for: title)
    }
    
    func question( at index: Int ) -> Question? {
        
        guard index >= 0,
            index < questions?.count ?? -1
            else {
                print( "Requested question \(index) but only \(questions?.count ?? -1) are present" )
                return nil
        }
        
        return questions?[ index ]
    }
}

