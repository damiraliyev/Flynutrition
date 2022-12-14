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
    
    let kgLabel = UILabel()
    
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
        
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setup() {
        
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.text = "Write your weight: "
        tipLabel.font = UIFont.systemFont(ofSize: 19)
        tipLabel.layer.opacity = 0.6
        
        weightTextField.translatesAutoresizingMaskIntoConstraints = false
        weightTextField.borderStyle = .roundedRect
        weightTextField.layer.borderColor = UIColor.black.cgColor
        weightTextField.textAlignment = .center
        weightTextField.backgroundColor = .white
        
        kgLabel.translatesAutoresizingMaskIntoConstraints = false
        kgLabel.text = "kg"
        kgLabel.layer.opacity = 0.8
        
        activeMode.translatesAutoresizingMaskIntoConstraints = false
        
        passiveMode.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func layout() {
        view.addSubview(tipLabel)
        view.addSubview(weightTextField)
        view.addSubview(kgLabel)
        view.addSubview(activeMode)
        view.addSubview(passiveMode)
        
        NSLayoutConstraint.activate([
            tipLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            tipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            weightTextField.centerYAnchor.constraint(equalTo: tipLabel.centerYAnchor),
            weightTextField.leadingAnchor.constraint(equalTo: tipLabel.trailingAnchor, constant: 16)
//            wei
        ])
        
        NSLayoutConstraint.activate([
            kgLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 8),
            kgLabel.centerYAnchor.constraint(equalTo: weightTextField.centerYAnchor)
        ])
        
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
