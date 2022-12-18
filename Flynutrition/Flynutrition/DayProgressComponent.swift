//
//  DayProgressComponent.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit

class DayProgressComponent: UIView {
    
    var calorieProgressView = CircularProgressView()
    var waterProgressView = CircularProgressView()

    var caloriesProgressComponent = NutrientCircularProgressView()
    var waterProgressComponent = NutrientCircularProgressView()
    
    let circularProgressStack = makeStackView(axis: .horizontal)
    
    let proteinsProgressBar = NutrientProgressBarView(nutrientName: "Proteins", requiredAmount: "105")
    let fatsProgressBar = NutrientProgressBarView(nutrientName: "Fats", requiredAmount: "63")
    let carbsProgressBar = NutrientProgressBarView(nutrientName: "Carbs", requiredAmount: "140")
    
    let nutrientsStack = makeStackView(axis: .horizontal)
    
    var frameOfCircularProgressView: CGRect = CGRect()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setup()
        layout()
    }
    
    init(circularProgressView: CircularProgressView) {
        super.init(frame: .zero)

        frameOfCircularProgressView = circularProgressView.frame
        setup()
        layout()
    }
    
    func setup() {
        calorieProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: frameOfCircularProgressView.width, height: 120), lineWidth: 10, rounded: false)
//
        waterProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: frameOfCircularProgressView.width, height: 120), lineWidth: 10, rounded: false)
        
        caloriesProgressComponent = NutrientCircularProgressView(circularProgressView: calorieProgressView ,imageName: "Vector.pdf", unit: "kC", color: .systemGreen)
        
        
        waterProgressComponent = NutrientCircularProgressView(circularProgressView: waterProgressView,imageName: "drop.pdf", unit: "ml", color: .systemBlue)
        

       
        
        circularProgressStack.translatesAutoresizingMaskIntoConstraints = false
        circularProgressStack.backgroundColor = .white
        circularProgressStack.distribution = .fillEqually
        circularProgressStack.spacing = frameOfCircularProgressView.width / 2
        
       
        nutrientsStack.translatesAutoresizingMaskIntoConstraints = false
        nutrientsStack.distribution = .fillEqually
        nutrientsStack.spacing = 25
        nutrientsStack.alignment = .center
        caloriesProgressComponent.translatesAutoresizingMaskIntoConstraints = false
        
        waterProgressComponent.translatesAutoresizingMaskIntoConstraints = false
        
        proteinsProgressBar.translatesAutoresizingMaskIntoConstraints = false
        
        fatsProgressBar.translatesAutoresizingMaskIntoConstraints = false
        
        carbsProgressBar.translatesAutoresizingMaskIntoConstraints = false

    }
    
    
    func layout() {
        
        
        addSubview(circularProgressStack)
        circularProgressStack.addArrangedSubview(caloriesProgressComponent)
        circularProgressStack.addArrangedSubview(waterProgressComponent)

        
        addSubview(nutrientsStack)
        nutrientsStack.addArrangedSubview(proteinsProgressBar)
        nutrientsStack.addArrangedSubview(fatsProgressBar)
        nutrientsStack.addArrangedSubview(carbsProgressBar)
    
        NSLayoutConstraint.activate([
            circularProgressStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            circularProgressStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            circularProgressStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        
        NSLayoutConstraint.activate([
            nutrientsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            nutrientsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nutrientsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        
        
    }
    
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: 200)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

