//
//  SetttingsViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 14.12.2022.
//

import Foundation
import UIKit


class SettingsViewController: UIViewController {
    
    let tipLabel = UILabel()
    
    let weightTextField = UITextField()
    
    let activityModeLabel = UILabel()
    
    let activeMode = ActivityModeView(isOn: true, modeText: "Active mode")
    
    let passiveMode = ActivityModeView(isOn: false, modeText: "Passive mode")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        view.backgroundColor = .white
        title = "Settings"
        setup()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        print(navigationController)
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setup() {
        activeMode.translatesAutoresizingMaskIntoConstraints = false
        
        passiveMode.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func layout() {
        view.addSubview(activeMode)
        view.addSubview(passiveMode)
        
        NSLayoutConstraint.activate([
            activeMode.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 128),
            activeMode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            passiveMode.topAnchor.constraint(equalTo: activeMode.bottomAnchor, constant: 24),
            passiveMode.leadingAnchor.constraint(equalTo: activeMode.leadingAnchor)
        ])
       
    }
    
    
}
