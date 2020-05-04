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

class QuizViewController: UIViewController {
    
    @IBOutlet weak var uiQuestionNumber : UILabel!
    @IBOutlet weak var uiQuestion       : UILabel!
    @IBOutlet weak var uiExplanation    : UITextView!
    @IBOutlet weak var uiStatString     : UILabel!
    @IBOutlet weak var uiButtonSubmit   : UIButton!
    
    @IBOutlet weak var uiAllSwitchAnswers: UIStackView!
    @IBOutlet weak var uiAllFillInTheBlankAnswers: UIStackView!
    
    @IBOutlet weak var uiFillInTheBlankMark     : UILabel!
    @IBOutlet weak var uiFillInTheBlankTextField: UITextField!
    @IBOutlet weak var uiFillInTheBlankAnswers  : UILabel!
    @IBOutlet weak var uiFillInTheBlankSpacer   : UILabel!
    
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
    
    let correctTextColor = UIColor( red: CGFloat(0.0),
                                    green: CGFloat(0.563),
                                    blue: CGFloat(0.319),
                                    alpha: CGFloat(1.0)
                                    )
    let incorrectTextColor = UIColor( red:CGFloat(1.0),
                                      green:CGFloat(0.0),
                                      blue:CGFloat(0.0),
                                      alpha:CGFloat(1.0)
                                      )
    
    var quiz = Quiz()
    var question: Question?
    
    var questionIndex = -1      // index into the actual question being asked

    var shuffledIndices = [Int]()   // shuffled indices into questions[]
    var missedIndices = [Int]()     // which (unshuffled) indices were answered incorrectly?
    var shuffledIndex = -1      // index into shuffledIndices, which names the questionIndex
    var mixedIndices: [Int]!    // for ANSWER randomization
    var reviewMode: ReviewMode = .Study
    var isShowingQuestion = true

    // user preferences
    var wantsShuffle = true
    var wantsAnswersRandomized = false
    
    // statistics
    var numQuestions = 0
    var numCorrect = 0
    
    enum BoolString: String
    {
        case YES = "Y"
        case NO = "N"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let quizToShow = AppDelegate.quizToShow else {
            print( "No quiz selected; returning to menu" )
            return
        }
        
        print( "showing quiz name=\(quizToShow.quizTitle), file=\(quizToShow.quizFilename)" )
        
        configureNavigationBar( with: quizToShow.quizTitle )
        uiFillInTheBlankTextField.delegate = self
        uiStatString.text = ""
        uiFillInTheBlankSpacer.text = ""

        loadMultipleChoiceUIComponentsIntoArrays()
        loadQuestions( for: quizToShow.quizTitle )
//        loadQuestionsFromJsonFile()
        
        guard quiz.numQuestions > 0 else {
            print( "Quiz is empty! Returning to menu" )
            return
        }
        
        initShuffledIndices()
        
        showNextQuestion()
    }
    
    private func configureNavigationBar( with title: String ) {
        
        let mainMenuItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(mainMenu))
        
        navigationItem.leftBarButtonItems = [ mainMenuItem ]
        
        navigationItem.title = title
    }
    private func loadMultipleChoiceUIComponentsIntoArrays() {
        
        switchArray = [ uiSwitchA, uiSwitchB, uiSwitchC, uiSwitchD, uiSwitchE ]
        switchLabelArray = [ uiSwitchALabel, uiSwitchBLabel, uiSwitchCLabel, uiSwitchDLabel, uiSwitchELabel ]
        answerMarkArray  = [ uiAnswerMarkA, uiAnswerMarkB, uiAnswerMarkC, uiAnswerMarkD, uiAnswerMarkE ]
        
        for switchControl in switchArray {
            switchControl.addTarget( self, action: #selector(switchToggled), for: .valueChanged )
        }
    }
    
    @objc private func mainMenu() {
        
        dismiss(animated: true, completion: nil)
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
    
    func loadQuestions(for title: String ) {
        quiz.loadQuestions(for: title)
    }
    
    func showNextQuestion() {
        
        shuffledIndex += 1
        if shuffledIndex >= shuffledIndices.count {
            if missedIndices.isEmpty {
                initShuffledIndices()
                clearStats( "Starting over" )
            }
            else {
                shuffledIndices = missedIndices
                missedIndices.removeAll()
                if wantsShuffle {
                    shuffleIndices()
                }
                clearStats( "Reviewing" )
            }
            shuffledIndex = 0
        }
        
        questionIndex = shuffledIndices[ shuffledIndex ]
        displayQuestionAt( index: questionIndex )
    }
    func displayQuestionAt( index: Int ) {
        
        question = quiz.question( at: index )
        guard let question = question else { return }
        
        if question.isFillInTheBlank {
            displayFillInTheBlankQuestion( question )
        }
        else {
            displayMultipleChoiceQuestion( question )
        }
    }

    func displayMultipleChoiceQuestion( _ qa: Question ) {
        
        uiAllSwitchAnswers.isHidden = false
        uiAllFillInTheBlankAnswers.isHidden = true

        resetChoicesUsing( numChoices: qa.numChoices )
        
        uiQuestionNumber.text   = "Question \(shuffledIndex + 1) (\(qa.questionNumber))"
        let questionText        = qa.question
        uiQuestion.text         = questionText
//        uiExplanation.text      = "\(qa["explanation"]!)"
        uiExplanation.isHidden  = true
        
        let choiceArray = [
            qa.choiceA,
            qa.choiceB,
            qa.choiceC,
            qa.choiceD,
            qa.choiceE,
        ]
        
        let answerIndices = Array(0 ..< qa.numChoices)
        mixedIndices = wantsAnswersRandomized ? answerIndices.shuffled() : answerIndices
        
        for (i, ch) in choiceLetters.enumerated() {
            if choiceArray[i] == "" {
                switchLabelArray[i].text = ""
            }
            else {
                switchLabelArray[i].text = "\(ch). \(choiceArray[ mixedIndices[i] ])"
            }
        }
        
        uiButtonSubmit.setTitle( "Submit Answer", for: .normal )
        
        isShowingQuestion = true
    }
    func displayFillInTheBlankQuestion( _ qa: Question ) {
        
        uiAllFillInTheBlankAnswers.isHidden = false
        uiAllSwitchAnswers.isHidden = true

        uiQuestionNumber.text   = "Question \(shuffledIndex + 1) (\(qa.questionNumber))"
        let questionText        = qa.question
        uiQuestion.text         = questionText
        uiExplanation.isHidden  = true
        
        uiFillInTheBlankTextField.text = ""
        uiFillInTheBlankAnswers.text = ""
        uiFillInTheBlankMark.text = ""
        
        uiButtonSubmit.setTitle( "Submit Answer", for: .normal )
        
        uiFillInTheBlankTextField.becomeFirstResponder()
        
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
        
        let numAnswers = question?.numAnswers ?? 0
        
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
        
        if uiFillInTheBlankTextField.isFirstResponder {
            uiFillInTheBlankTextField.resignFirstResponder()
        }
        
        checkAnswers()
    }
    func checkAnswers() {
        
        guard let question = question else { return }
        
        if question.isFillInTheBlank {
            checkAnswerFillInTheBlank( question )
        }
        else {
            checkAnswerMultipleChoice( question )
        }
    }
    
    func checkAnswerMultipleChoice( _ qa: Question ) {
        
        let myAnswers = buildAnswers()
        let correctAnswersOriginal = qa.correctAnswers
        let correctAnswers = wantsAnswersRandomized
            ? adjustAnswersForRandomization(correctAnswersOriginal)
            : correctAnswersOriginal
        
        updateStats(correct: myAnswers == correctAnswers)
        if myAnswers != correctAnswers {
            missedIndices.append( questionIndex )
        }
        
        uiExplanation.text      = "\(qa.explanation)"
        uiExplanation.isHidden  = false
        
        uiButtonSubmit.setTitle( "Next Question", for: .normal )

        markAnswers( myAnswers:myAnswers, correctAnswers:correctAnswers )
    }
    func adjustAnswersForRandomization( _ answers: String ) -> String {
        
        var mixedAnswers = ""
        choiceLetters.enumerated().forEach { (tuple) in
            if answers.contains( tuple.element ) {
                let newOffset = mixedIndices.firstIndex(of: tuple.offset)!
                mixedAnswers.append( choiceLetters[newOffset])
            }
        }
        
        return String(mixedAnswers.sorted())
    }
    
    func checkAnswerFillInTheBlank( _ qa: Question ) {
        
//        uiFillInTheBlankTextField.resignFirstResponder()
        
        let fillAnswers = assembleFillAnswers( qa )
        
        let userAnswer = uiFillInTheBlankTextField.text ?? ""
        
        var isCorrect = false
        for answer in fillAnswers {
            if answer == userAnswer {
                isCorrect = true
                break
            }
        }
        
        var answers = fillAnswers.joined(separator: "\n")
        if answers.isEmpty { answers = "?" }
        
        uiFillInTheBlankMark.text           = isCorrect ? correctAnswerMark : incorrectAnswerMark
        uiFillInTheBlankAnswers.textColor   = isCorrect ? correctTextColor : incorrectTextColor
        uiFillInTheBlankAnswers.text        = answers

        updateStats(correct: isCorrect)
        if !isCorrect {
            missedIndices.append( questionIndex )
        }

        uiButtonSubmit.setTitle( "Next Question", for: .normal )
    }
    func assembleFillAnswers( _ qa: Question ) -> [String] {
        var fillAnswers = [String]()
        
        let numFillAnswers = qa.numFillAnswers
        if numFillAnswers > 0 { fillAnswers.append( qa.fillAnswerA )}
        if numFillAnswers > 1 { fillAnswers.append( qa.fillAnswerB )}
        if numFillAnswers > 2 { fillAnswers.append( qa.fillAnswerC )}
        if numFillAnswers > 3 { fillAnswers.append( qa.fillAnswerD )}
        if numFillAnswers > 4 { fillAnswers.append( qa.fillAnswerE )}

        return fillAnswers
    }
    func updateStats( correct: Bool ) {
        
        numQuestions += 1
        numCorrect += ( correct ? 1 : 0 )
        
        let pctCorrect = 100.0 * Double(numCorrect) / Double(numQuestions)
        let pctString  = String( format: "%.2f", pctCorrect )
        
        uiStatString.text = "\(numCorrect) / \(numQuestions) (\(pctString)%)"
    }
    func clearStats( _ msg: String = "" ) {
        
        numQuestions = 0
        numCorrect = 0
        uiStatString.text = msg
    }
    
    func markAnswers( myAnswers:String, correctAnswers:String ) {
        
        guard let question = question else { return }
        
        for i in 0 ..< question.numChoices {
            
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
        
        guard let question = question else { return "?" }
        
        var results = ""
        for i in 0 ..< question.numChoices {
            if switchArray[i].isOn {
                results += choiceLetters[ i ]
            }
        }
        return results
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension QuizViewController: UITextFieldDelegate
{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        processAnswer( uiButtonSubmit )
        return true
    }
}

/*
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
*/

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
