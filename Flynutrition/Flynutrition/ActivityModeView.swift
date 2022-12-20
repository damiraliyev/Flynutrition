//
//  ActivityModeView.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 14.12.2022.
//

import Foundation
import UIKit

protocol SwitchDelegate: AnyObject {
    func switchTurned(id: Int)
}

class ActivityModeView: UIView {
    
    let isOnSwitch = UISwitch()
    let modeLabel = UILabel()
    
    var id = 0
    
    weak var switchDelegate: SwitchDelegate?

    init(isOn: Bool, modeText: String, id: Int) {
        super.init(frame: .zero)
        
//        backgroundColor = .systemGray6
        
        isOnSwitch.translatesAutoresizingMaskIntoConstraints = false
        isOnSwitch.isOn = isOn
        
        
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.text = modeText
        modeLabel.font = UIFont.systemFont(ofSize: 18)
        modeLabel.textColor = .black
        
        self.id = id
        
        layout()
        
    }

    func layout() {

        
        addSubview(isOnSwitch)
        addSubview(modeLabel)
        
        isOnSwitch.addTarget(self, action: #selector(switchChanged), for: .primaryActionTriggered)
        
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
    
    @objc func switchChanged() {
        print("switch Changed")
        switchDelegate?.switchTurned(id: id)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 150, height: 20)
    }
    
}
