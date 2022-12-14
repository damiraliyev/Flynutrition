//
//  ActivityModeView.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 14.12.2022.
//

import Foundation
import UIKit

class ActivityModeView: UIView {
    
    let isOnSwitch = UISwitch()
    let modeLabel = UILabel()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setup()
//        layout()
//    }
//
    init(isOn: Bool, modeText: String) {
        super.init(frame: .zero)
        
//        backgroundColor = .systemGray6
        
        isOnSwitch.translatesAutoresizingMaskIntoConstraints = false
        isOnSwitch.isOn = isOn
        
        
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.text = modeText
        modeLabel.font = UIFont.systemFont(ofSize: 20)
        modeLabel.textColor = .black
        
        layout()
        
    }

    func layout() {

        
        addSubview(isOnSwitch)
        addSubview(modeLabel)
        
        isOnSwitch.addTarget(self, action: #selector(printSMTh), for: .primaryActionTriggered)
        
        NSLayoutConstraint.activate([
            isOnSwitch.topAnchor.constraint(equalTo: topAnchor),
            isOnSwitch.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            modeLabel.centerYAnchor.constraint(equalTo: isOnSwitch.centerYAnchor),
            modeLabel.leadingAnchor.constraint(equalTo: isOnSwitch.trailingAnchor, constant: 16)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func printSMTh() {
        print("AA")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 150, height: 20)
    }
    
}
