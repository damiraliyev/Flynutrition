//
//  NutrientView+Info.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 16.11.2022.
//

import Foundation
import UIKit

class NutrientInfo: UIView {
    let stackView = makeStackView(axis: .vertical)
    
    let nutrientImageView = UIImageView()
    let nutrientNameLabel = UILabel()
    var amountLabel = UILabel()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        layout()
    }
    
    init(name: String, amount: Float, imageName: String) {
        super.init(frame: .zero)
        setup()
        
        nutrientImageView.image = UIImage(named: imageName)
        
        nutrientNameLabel.text = name
        
        
        
        amountLabel.text = String(amount) + "g"
        
        
        layout()
    }
    
    func setup() {
        stackView.alignment = .center
        
        nutrientImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nutrientNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nutrientNameLabel.font = UIFont.systemFont(ofSize: 15)
        nutrientNameLabel.textColor = .systemOrange

        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.font = UIFont.systemFont(ofSize: 14)
        amountLabel.textColor = .orange
        
        
    }
    
    func layout() {
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(nutrientImageView)
        stackView.addArrangedSubview(nutrientNameLabel)
        stackView.addArrangedSubview(amountLabel)
    
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nutrientImageView.widthAnchor.constraint(equalToConstant: 35),
            nutrientImageView.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 40, height: 50)
    }
}
