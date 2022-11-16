//
//  AppDelegate.swift
//
//  Created by Apple on 3/1/21.
//

import UIKit
import Firebase

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        LocationManager.handleEnterForeground()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        LocationManager.handleEnterBackground()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        LocationManager.handleAppKilled()
    }
}

