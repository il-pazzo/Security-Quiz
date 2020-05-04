//
//  QuestionSelector.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 5/3/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

class QuestionSelector {
    
    var quiz: Quiz
    
    var wantsShuffle = true
    var shuffledIndices = [Int]()
    var shuffledIndex = -1      // index into shuffledIndices, which names the questionIndex
    var missedIndices = [Int]()     // which (unshuffled) indices were answered incorrectly?
    
    var currentQuestionIndex: Int?

    init( quiz: Quiz ) {
        self.quiz = quiz
    }
    
    func initShuffledIndices() {
    
        shuffledIndices = Array( 0 ..< quiz.numQuestions )

        if wantsShuffle {
            shuffleIndices()
        }
    }
    private func shuffleIndices() {
        
        shuffledIndices.shuffle()
    }

    func nextQuestion() -> Question? {
        
        shuffledIndex += 1
        if shuffledIndex >= shuffledIndices.count {
            if missedIndices.isEmpty {
                initShuffledIndices()
//                clearStats( "Starting over" )
            }
            else {
                shuffledIndices = missedIndices
                missedIndices.removeAll()
                if wantsShuffle {
                    shuffleIndices()
                }
//                clearStats( "Reviewing" )
            }
            shuffledIndex = 0
        }
        
        currentQuestionIndex = shuffledIndices[ shuffledIndex ]
        guard let currentQuestionIndex = currentQuestionIndex else { return nil }
        
        return quiz.question(at: currentQuestionIndex)
    }
    
    func noteMissedQuestion() {
        
        guard let currentQuestionIndex = currentQuestionIndex else { return }
        
        missedIndices.append( currentQuestionIndex )
    }
}
