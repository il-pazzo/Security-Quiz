//
//  WhichQuizViewController.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 9/18/19.
//  Copyright © 2019 Glenn Cole. All rights reserved.
//

import UIKit

class WhichQuizViewController: UIViewController {
    
    let quizSets: [ QuizToShow ] = [
        ("SY0-501", "mmsy0501_exam_1"),
        ("LX0-103", "LX0-103"),
        ("LX0-104", "LX0-104"),
        ("test2", "questions_2"),
        ("test3", "questions-3"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension WhichQuizViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WhichQuizCell")!
        
        cell.textLabel?.text = quizSets[ indexPath.row ].quizTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AppDelegate.quizToShow = quizSets[ indexPath.row ]
        
        performSegue(withIdentifier: "presentQuiz", sender: self)
    }
}
