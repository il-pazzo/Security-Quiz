//
//  AppDelegate.swift
//  Security+ Quiz
//
//  Created by Glenn Cole on 4/1/18.
//  Copyright © 2018 Glenn Cole. All rights reserved.
//

import UIKit

struct QuizInfo {
    let quizTitle: String
    let quizFilename: String
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var quizToShow: QuizInfo?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

}

