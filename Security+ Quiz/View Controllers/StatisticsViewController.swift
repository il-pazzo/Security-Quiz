//
//  StatisticsViewController.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 4/1/18.
//  Copyright © 2018 Glenn Cole. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var uiThisQuestionsOverallNum: UILabel!
    @IBOutlet weak var uiThisQuestionsOverallPct: UILabel!
    @IBOutlet weak var uiThisQuestionsCorrectNum: UILabel!
    @IBOutlet weak var uiThisQuestionsCorrectPct: UILabel!
    @IBOutlet weak var uiThisQuestionsIncorrectNum: UILabel!
    @IBOutlet weak var uiThisQuestionsIncorrectPct: UILabel!
    
    @IBOutlet weak var uiTotalQuestionsOverallNum: UILabel!
    @IBOutlet weak var uiTotalQuestionsOverallPct: UILabel!
    @IBOutlet weak var uiTotalQuestionsCorrectNum: UILabel!
    @IBOutlet weak var uiTotalQuestionsCorrectPct: UILabel!
    @IBOutlet weak var uiTotalQuestionsIncorrectNum: UILabel!
    @IBOutlet weak var uiTotalQuestionsIncorrectPct: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
