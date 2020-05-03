//
//  WhichQuizViewController.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 9/18/19.
//  Copyright © 2019 Glenn Cole. All rights reserved.
//

import UIKit

class WhichQuizViewController: UIViewController {
    
    let quizStore: QuizData = QuizStore()
    var quizSets: [QuizInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        quizSets = quizStore.quizInfo
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
