//
//  NutrientProgressBarView.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit

class NutrientProgressBarView: UIView {
    
    let nutrientNameLabel = UILabel()
    let progressBar = UIProgressView()
    
    let consumedAmountLabel = UILabel()
    let requiredAmountLabel = UILabel()
    
    let combinedAmountLabel = UILabel()
    
    let stackView = makeStackView(axis: .vertical)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    init(nutrientName: String, requiredAmount: String) {
        super.init(frame: .zero)
        nutrientNameLabel.text = nutrientName
        requiredAmountLabel.text = requiredAmount
        setup()
        layout()
    }
    
    
    func setup() {
        
        stackView.spacing = 5
        
        nutrientNameLabel.translatesAutoresizingMaskIntoConstraints = false
        nutrientNameLabel.font = UIFont.systemFont(ofSize: 16)
        nutrientNameLabel.textColor = .systemOrange
        nutrientNameLabel.textAlignment = .center
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .systemOrange
        progressBar.trackTintColor = .systemGray2
//        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3)
        
        consumedAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        consumedAmountLabel.textColor = .systemOrange
        consumedAmountLabel.font = UIFont.systemFont(ofSize: 8)
        
        
        requiredAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        requiredAmountLabel.textColor = .systemOrange
        requiredAmountLabel.font = UIFont.systemFont(ofSize: 8)
        
        combinedAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        combinedAmountLabel.text = consumedAmountLabel.text ?? "0" + "/" + requiredAmountLabel.text!
        combinedAmountLabel.textColor = .systemOrange
        combinedAmountLabel.textAlignment = .center
    }
    
    func layout() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(nutrientNameLabel)
        stackView.addArrangedSubview(progressBar)
        stackView.addArrangedSubview(combinedAmountLabel)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

