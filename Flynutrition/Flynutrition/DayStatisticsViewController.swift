//
//  ViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import UIKit

class DayStatisticsViewController: UIViewController {
    
    let todayLabel = makeLabel(withText: "Today")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .tertiarySystemBackground
        setup()
        layout()
    }
    
    
    func setup() {
        todayLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        todayLabel.attributedText = NSAttributedString(string: todayLabel.text!, attributes: [.kern: 1])
        
        
    }
    
    func layout() {
        view.addSubview(todayLabel)
        
        NSLayoutConstraint.activate([
            todayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            todayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }




}

