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
    
    let proteinsProgressBar = NutrientProgressBarView(nutrientName: "Proteins", requiredAmount: "130")
    let carbsProgressBar = NutrientProgressBarView(nutrientName: "Fats", requiredAmount: "170")
    let fatsProgressBar = NutrientProgressBarView(nutrientName: "Carbs", requiredAmount: "200")
    
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
        
        caloriesProgressComponent = NutrientCircularProgressView(circularProgressView: calorieProgressView ,imageName: "flame.fill", unit: "kC", color: .systemOrange)
        
        
        waterProgressComponent = NutrientCircularProgressView(circularProgressView: waterProgressView,imageName: "drop.fill", unit: "ml", color: .systemBlue)
        

        
        
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
        
        carbsProgressBar.translatesAutoresizingMaskIntoConstraints = false
        
        fatsProgressBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        print(caloriesProgressComponent.bounds.size.width)
                
    }
    
    
    func layout() {
        
        
        addSubview(circularProgressStack)
        circularProgressStack.addArrangedSubview(caloriesProgressComponent)
        circularProgressStack.addArrangedSubview(waterProgressComponent)

        
        addSubview(nutrientsStack)
        nutrientsStack.addArrangedSubview(proteinsProgressBar)
        nutrientsStack.addArrangedSubview(carbsProgressBar)
        nutrientsStack.addArrangedSubview(fatsProgressBar)
    
        NSLayoutConstraint.activate([
            circularProgressStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            circularProgressStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            circularProgressStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        
        NSLayoutConstraint.activate([
            nutrientsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
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

