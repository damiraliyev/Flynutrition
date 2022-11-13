//
//  MainTabBarController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        delegate = self
        
        setupTabBar()
    }
    
    func setupTabBar() {
        let dayStatisticsVC = DayStatisticsViewController()
        dayStatisticsVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house.fill"), selectedImage: nil)
        
        
//        let tabBarAppearance = UITabBarAppearance()
//        tabBarAppearance.configureWithOpaqueBackground()
//        tabBarAppearance.backgroundColor = .systemBackground
//        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        viewControllers = [dayStatisticsVC]
        
        loadAllControllers()
        
    }
    
    func loadAllControllers() {
        if let viewControllers = self.viewControllers {
            for viewController in viewControllers {
                if let navVC = viewController as? UINavigationController {
                    print("true")
                    let _ = navVC.viewControllers.first?.view
                }
               
            }
        }
    }

    
}

extension MainTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
          return false // Make sure you want this as false
        }

        if fromView != toView {
          UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }

        return true
    }
}

