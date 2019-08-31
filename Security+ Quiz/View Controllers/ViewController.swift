//
//  ViewController.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 4/1/18.
//  Copyright © 2018 Glenn Cole. All rights reserved.
//

import UIKit

enum ReviewMode {
    case Study, Test
}

class ViewController: UIViewController {
    
    @IBOutlet weak var uiQuestionNumber : UILabel!
    @IBOutlet weak var uiQuestion       : UILabel!
    @IBOutlet weak var uiExplanation    : UITextView!
    @IBOutlet weak var uiStatString     : UILabel!
    @IBOutlet weak var uiButtonSubmit   : UIButton!
    
    @IBOutlet weak var uiAnswerMarkA: UILabel!
    @IBOutlet weak var uiAnswerMarkB: UILabel!
    @IBOutlet weak var uiAnswerMarkC: UILabel!
    @IBOutlet weak var uiAnswerMarkD: UILabel!
    @IBOutlet weak var uiAnswerMarkE: UILabel!
    
    
    @IBOutlet weak var uiSwitchA: UISwitch!
    @IBOutlet weak var uiSwitchB: UISwitch!
    @IBOutlet weak var uiSwitchC: UISwitch!
    @IBOutlet weak var uiSwitchD: UISwitch!
    @IBOutlet weak var uiSwitchE: UISwitch!
    
    @IBOutlet weak var uiSwitchALabel: UILabel!
    @IBOutlet weak var uiSwitchBLabel: UILabel!
    @IBOutlet weak var uiSwitchCLabel: UILabel!
    @IBOutlet weak var uiSwitchDLabel: UILabel!
    @IBOutlet weak var uiSwitchELabel: UILabel!
    
    var switchArray     : [ UISwitch ]!
    var switchLabelArray: [ UILabel ]!
    var answerMarkArray : [ UILabel ]!
    let choiceLetters = [ "A","B","C","D","E" ]
    
    let correctAnswerMark = "✅"
    let incorrectAnswerMark = "❌"
    

    var questions = [ [String:String] ]()
    var questionIndex = -1      // index into the actual question being asked
    var shuffledIndices = [Int]()
    var shuffledIndex = -1      // index into shuffledIndices, which names the questionIndex
    var reviewMode: ReviewMode = .Study
    var isShowingQuestion = true
    
    var numQuestions = 0
    var numCorrect = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        switchArray = [ uiSwitchA, uiSwitchB, uiSwitchC, uiSwitchD, uiSwitchE ]
        switchLabelArray = [ uiSwitchALabel, uiSwitchBLabel, uiSwitchCLabel, uiSwitchDLabel, uiSwitchELabel ]
        answerMarkArray  = [ uiAnswerMarkA, uiAnswerMarkB, uiAnswerMarkC, uiAnswerMarkD, uiAnswerMarkE ]
        
        for switchControl in switchArray {
            switchControl.addTarget( self, action: #selector(switchToggled), for: .valueChanged )
        }
        
        loadQuestionsFromJsonFile()
        initShuffledIndices()
        
        uiStatString.text = ""

        if questions.count > 0 {
            showNextQuestion()
        }
    }
    
    func initShuffledIndices() {
    
//        for i in 0 ..< questions.count {
//            shuffledIndices.append( i )
//        }
        shuffledIndices = Array( 0 ..< questions.count )

        shuffleIndices()
    }
    func shuffleIndices() {
        
        shuffledIndices.shuffle()
    }
    
    func loadQuestionsFromJsonFile() {
        
        if let jsonFilePath = Bundle.main.path(forResource: "mmsy0501_exam_1", ofType: "json" ) {
            if let jsonData = try? String.init(contentsOfFile: jsonFilePath ) {
                
                let json = JSON( parseJSON: jsonData )
//                if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                
                    parse( json: json )
                
                    return
//                }
            }
        }
    }
    func parse( json: JSON ) {
        
        for qa in json["questions"].arrayValue {
            
            let questionNumber      = String( qa["question_number"].intValue )
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

            let obj = [ "question"      :question,
                        "explanation"   :explanation,
                        "questionNumber":questionNumber,
                        "hint"          :hint,
                        "correctAnswers":correctAnswers,
                        "choiceA"       :choiceA,
                        "choiceB"       :choiceB,
                        "choiceC"       :choiceC,
                        "choiceD"       :choiceD,
                        "choiceE"       :choiceE,
                        "numChoices"    :String( choices.count )
                        ]
            questions.append( obj )
        }
    }
    
    func showNextQuestion() {
        
        shuffledIndex += 1
        if shuffledIndex >= shuffledIndices.count {
            shuffleIndices()
            shuffledIndex = 0
        }
        
        questionIndex = shuffledIndices[ shuffledIndex ]
        displayQuestionAt( index: questionIndex )
    }
    func displayQuestionAt( index: Int ) {
        
        let qa = questions[ index ]
        
        resetChoicesUsing( numChoices: Int( qa["numChoices"]! )! )
        
        uiQuestionNumber.text   = "Question \(shuffledIndex + 1) (\(qa["questionNumber"]!))"
        uiQuestion.text         = "\(qa["question"]!)"
//        uiExplanation.text      = "\(qa["explanation"]!)"
        uiExplanation.isHidden  = true
        
        uiSwitchALabel.text     = "A. \(qa["choiceA"]!)"
        uiSwitchBLabel.text     = "B. \(qa["choiceB"]!)"
        uiSwitchCLabel.text     = "C. \(qa["choiceC"]!)"
        uiSwitchDLabel.text     = "D. \(qa["choiceD"]!)"
        uiSwitchELabel.text     = "E. \(qa["choiceE"]!)"
        
        uiButtonSubmit.setTitle( "Submit Answer", for: .normal )
        
        isShowingQuestion = true
    }
    func resetChoicesUsing( numChoices: Int ) {

        for i in 0 ..< switchArray.count {
            
            if i < numChoices {
                switchArray[i].isHidden = false
                switchArray[i].isEnabled = true
                switchArray[i].setOn( false, animated:false )
                
                switchLabelArray[i].isHidden = false
                
                answerMarkArray[i].text = ""
                answerMarkArray[i].isHidden = false
            }
            else {
                switchArray[i].isHidden = true
                switchLabelArray[i].isHidden = true
                answerMarkArray[i].isHidden = true
            }
        }
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        
        let numAnswers = questions[questionIndex]["correctAnswers"]!.count
        
        if numAnswers == 1  &&  sender.isOn {
            ensureAllSwitchesOffExcept( tag: sender.tag )
        }
    }
    func ensureAllSwitchesOffExcept( tag: Int ) {
        
        for i in 0 ..< switchArray.count {
            
            if switchArray[i].isOn  &&  switchArray[i].tag != tag {
                switchArray[i].setOn( false, animated: true )
            }
        }
    }
    
    
    @IBAction func processAnswer(_ sender: UIButton) {
        
        if !isShowingQuestion {
            showNextQuestion()
            return
        }

        isShowingQuestion = false
        checkAnswers()
    }
    func checkAnswers() {
        
        let myAnswers = buildAnswers()
        let correctAnswers = questions[questionIndex]["correctAnswers"]!
        
        if myAnswers == correctAnswers {
            updateStats( correct: true )
        }
        else {
            updateStats( correct: false )
        }
        
        uiExplanation.text      = "\(questions[questionIndex]["explanation"]!)"
        uiExplanation.isHidden  = false
        
        uiButtonSubmit.setTitle( "Next Question", for: .normal )

        markAnswers( myAnswers:myAnswers, correctAnswers:correctAnswers )
    }
    func updateStats( correct: Bool ) {
        
        numQuestions += 1
        numCorrect += ( correct ? 1 : 0 )
        
        let pctCorrect = 100.0 * Double(numCorrect) / Double(numQuestions)
        let pctString  = String( format: "%.2f", pctCorrect )
        
        uiStatString.text = "\(numCorrect) / \(numQuestions) (\(pctString)%)"
    }
    func markAnswers( myAnswers:String, correctAnswers:String ) {
        
        for i in 0 ..< Int( questions[questionIndex]["numChoices"]! )! {
            
            switchArray[i].isEnabled = false

            let answerLetter = choiceLetters[i]
            if correctAnswers.range(of: answerLetter) != nil {
                // this letter is in the answers; did WE get it?
                //
                if myAnswers.range(of: answerLetter) != nil {
                    // yes!
                    //
                    answerMarkArray[i].text = correctAnswerMark
                }
                else {
                    // uhhh...no
                    //
                    answerMarkArray[i].text = incorrectAnswerMark
                }
            }
            else if myAnswers.range(of: answerLetter) != nil {
                // hmmm...WE said it was correct, but it wasn't; oops
                //
                answerMarkArray[i].text = incorrectAnswerMark
            }
        }
    }
    func buildAnswers() -> String {
        
        var result = ""
        for i in 0 ..< Int( questions[questionIndex]["numChoices"]! )! {
            if switchArray[i].isOn {
                result += choiceLetters[ i ]
            }
        }
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            // Change `Int` in the next line to `IndexDistance` in < Swift 4.1
            let d: Int = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

// shuffle examples:
//
//let x = [1, 2, 3].shuffled()
//// x == [2, 3, 1]
//
//let fiveStrings = stride(from: 0, through: 100, by: 5).map(String.init).shuffled()
//// fiveStrings == ["20", "45", "70", "30", ...]
//
//var numbers = [1, 2, 3, 4]
//numbers.shuffle()
//// numbers == [3, 2, 1, 4]
