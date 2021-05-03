//
//  AppDelegate.swift
//  Apps Challenge
//
//  Created by Francisco Javier Sarasua Galan on 17/04/2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = nil
    let managerCoreData = CoreDataManager.sharedInstance

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /* TODO: Testing. Remove in the future. */
        self.managerCoreData.deleteAll()
        self.managerCoreData.initCoreData()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = BudgetListRouter.createModule()
            
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
