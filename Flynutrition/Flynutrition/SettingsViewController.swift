//
//  SetttingsViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 14.12.2022.
//

import Foundation
import UIKit

var activeModeMeasures: [String: Double] = ["proteins": 1.8, "fats": 1.4, "carbs": 5]
var passiveModeMeasures: [String: Double] = ["proteins": 0.8, "fats": 1.1, "carbs": 3.5]
class SettingsViewController: UIViewController {
    
    let tipLabel = UILabel()
    
    let weightTextField = UITextField()
    
    let kgLabel = UILabel()
    
    let activityModeLabel = UILabel()
    
    var weight: Double = LocalState.weight
    
    var activeMode = ActivityModeView(isOn: true, modeText: "Active mode", id: 0)
    
//    var activeModeMeasures: [String: Double] = ["proteins": 1.5, "fats": 0.9, "carbs": 2.0]
//
    let passiveMode = ActivityModeView(isOn: false, modeText: "Passive mode", id: 1)

    let applyButton = makeButton(color: .systemBlue)
    
    let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Settings"
        setup()
        layout()
        setupNavBar()
        
        activeMode.switchDelegate = self
        passiveMode.switchDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
   
    }
    
    func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
        weightTextField.text = String(weight)
        weightTextField.delegate = self
        weightTextField.addTarget(self, action: #selector(weightTextFieldChanged), for: .editingChanged)
        
        kgLabel.translatesAutoresizingMaskIntoConstraints = false
        kgLabel.text = "kg"
        kgLabel.layer.opacity = 0.8
        
        activeMode.translatesAutoresizingMaskIntoConstraints = false
        
        passiveMode.translatesAutoresizingMaskIntoConstraints = false
        
        
        applyButton.setTitle("Apply", for: .normal)
        applyButton.layer.cornerRadius = 5
        applyButton.addTarget(self, action: #selector(applySettings), for: .primaryActionTriggered)
        
        
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Please, write a number to a text field."
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        
        
        if LocalState.mode == 0 {
            activeMode.isOnSwitch.isOn = true
            passiveMode.isOnSwitch.isOn = false
        } else {
            activeMode.isOnSwitch.isOn = false
            passiveMode.isOnSwitch.isOn = true
        }
    }
    
    
    func layout() {
        view.addSubview(tipLabel)
        view.addSubview(weightTextField)
        view.addSubview(errorLabel)
        view.addSubview(kgLabel)
        view.addSubview(activeMode)
        view.addSubview(passiveMode)
        view.addSubview(applyButton)
        
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
            errorLabel.leadingAnchor.constraint(equalTo: tipLabel.leadingAnchor),
            errorLabel.topAnchor.constraint(equalTo: tipLabel.bottomAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            kgLabel.leadingAnchor.constraint(equalTo: weightTextField.trailingAnchor, constant: 8),
            kgLabel.centerYAnchor.constraint(equalTo: weightTextField.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activeMode.topAnchor.constraint(equalTo: weightTextField.bottomAnchor,constant: 32),
            activeMode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            passiveMode.topAnchor.constraint(equalTo: activeMode.bottomAnchor, constant: 24),
            passiveMode.leadingAnchor.constraint(equalTo: activeMode.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            applyButton.topAnchor.constraint(equalTo: passiveMode.bottomAnchor, constant: 64),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 100),
            applyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
       
    }
    
    @objc func applySettings() {
        applyButton.addClickAnimation()
        
        if let weightValue = Double(weightTextField.text!) {
            errorLabel.isHidden = true
            if activeMode.isOnSwitch.isOn {
                activeModeMeasures["weight"] = weightValue
                NotificationCenter.default.post(name: modeChanged, object: nil, userInfo: activeModeMeasures)
                print("Active mode measures should be posted")
            } else {
                passiveModeMeasures["weight"] = weightValue
                NotificationCenter.default.post(name: modeChanged, object: nil, userInfo: passiveModeMeasures)
                print("Passive mode measures should be posted")
            }
        } else {
            errorLabel.isHidden = false
            return
        }
        
    }
    

}


extension SettingsViewController: SwitchDelegate {
    func switchTurned(id: Int) {
        
        if id == 0 {
            passiveMode.isOnSwitch.isOn = !activeMode.isOnSwitch.isOn
            
        } else if id == 1 {
            activeMode.isOnSwitch.isOn = !passiveMode.isOnSwitch.isOn
        }
        
        if activeMode.isOnSwitch.isOn {
            LocalState.mode = 0
        } else {
            LocalState.mode = 1
        }
        
    }
}


extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if Double(textField.text!) == nil {
            textField.text = String(weight)
            return true
        } else {
            weight = Double(textField.text!)!
            return true
        }
    }
    
    @objc func weightTextFieldChanged(_ sender: UITextField) {

    }
}
