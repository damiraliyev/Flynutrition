//
//  LabelTextFieldView.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 18.12.2022.
//

import Foundation
import UIKit

class LabelTextFieldView: UIView {
    
    let label = UILabel()
    let textField = UITextField()
    
    let bottomLineView = UIView()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    init(text: String) {
        super.init(frame: .zero)
        
        
        setup(text: text)
        
        layout()
        
       
    }
    
    func setup(text: String) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.alpha = 0.5
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomLineView.backgroundColor = .systemGray3
    }
    
    func layout() {
        addSubview(label)
        addSubview(textField)
        addSubview(bottomLineView)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3),
            textField.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomLineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 120, height: 45)
    }
    
}
