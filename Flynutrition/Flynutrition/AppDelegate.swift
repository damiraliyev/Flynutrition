//
//  AppDelegate.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 

    var window: UIWindow?
    let navigationController = UINavigationController()
//    let dayStatisticsViewController = DayStatisticsViewController()
    let mainTabBarController = MainTabBarController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = mainTabBarController
//        window?.rootViewController = SettingsViewController()
        window?.overrideUserInterfaceStyle = .light
        
        
        
        return true
    }
    
    func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.standardAppearance = appearance
        
    }

   
}

