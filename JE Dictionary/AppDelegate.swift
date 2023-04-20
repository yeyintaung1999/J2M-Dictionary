//
//  AppDelegate.swift
//  JE Dictionary
//
//  Created by Ye Yint Aung on 11/04/2023.
//

import UIKit
import SQLite
var database: Connection!
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let fileUrl = Bundle.main.url(forResource: "sqlite", withExtension: ".db")!
        database = try! Connection(fileUrl.path)
        let option = UserDefaults.standard.string(forKey: "searchOption")
        if option == nil || option!.isEmpty {
            UserDefaults.standard.set("romaji", forKey: "searchOption")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

