//
//  NutrientCircularProgressView.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit

class NutrientCircularProgressView: UIView {
    var nutritionProgressView = CircularProgressView()
   
    let elementImageView =  UIImageView(image: UIImage(systemName: "flame.fill"))
    
    let elementRemainLabel = UILabel()
   
    var unit = ""
    
    
    let left1 = UILabel()
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
        
    }
    
    init(circularProgressView: CircularProgressView, imageName: String, unit: String, color: UIColor) {
        super.init(frame: .zero)
        
        self.unit = unit
        
     
        
        
        nutritionProgressView = circularProgressView
        nutritionProgressView.trackColor = .systemGray4
        
        
        elementImageView.image = UIImage(systemName: imageName)
        elementRemainLabel.textColor = color
        elementImageView.tintColor = color
        nutritionProgressView.progressColor = color
        setup()
        layout()
    }
    
    func setup() {
        
        nutritionProgressView.translatesAutoresizingMaskIntoConstraints = false

        nutritionProgressView.progress = 0.5
        
        elementImageView.translatesAutoresizingMaskIntoConstraints = false
       
        elementRemainLabel.translatesAutoresizingMaskIntoConstraints = false
        elementRemainLabel.text = "500 " + unit
        elementRemainLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
    
        left1.translatesAutoresizingMaskIntoConstraints = false
        left1.textColor = .systemGray
        left1.font = UIFont.systemFont(ofSize: 15)
        left1.text = "left"
       
        
    }
    
    
    func layout() {
        addSubview(nutritionProgressView)
        
        addSubview(elementImageView)

        
        addSubview(elementRemainLabel)

        
        addSubview(left1)
        
        print(nutritionProgressView.getLineWidth(), "line width")
        
        //CaloriesProgressView layout
        NSLayoutConstraint.activate([

            nutritionProgressView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -nutritionProgressView.center.x),
            nutritionProgressView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: nutritionProgressView.getLineWidth()),
            nutritionProgressView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            elementImageView.topAnchor.constraint(equalTo: nutritionProgressView.topAnchor, constant: nutritionProgressView.getLineWidth() * 2),
            elementImageView.centerXAnchor.constraint(equalTo: nutritionProgressView.leadingAnchor, constant: nutritionProgressView.center.x),
            elementImageView.widthAnchor.constraint(equalToConstant: nutritionProgressView.bounds.size.width / 5),
            elementImageView.heightAnchor.constraint(equalToConstant: nutritionProgressView.bounds.size.width / 5)
        ])
        
        NSLayoutConstraint.activate([
            elementRemainLabel.topAnchor.constraint(equalTo: elementImageView.bottomAnchor, constant: 3),
            elementRemainLabel.centerXAnchor.constraint(equalTo: nutritionProgressView.leadingAnchor, constant: nutritionProgressView.center.x)
        ])
        
        NSLayoutConstraint.activate([
            left1.topAnchor.constraint(equalTo: elementRemainLabel.bottomAnchor, constant: 3),
            left1.centerXAnchor.constraint(equalTo: nutritionProgressView.leadingAnchor, constant: nutritionProgressView.center.x)
        ])

        
        
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: nutritionProgressView.bounds.size.width + nutritionProgressView.getLineWidth(), height: nutritionProgressView.bounds.size.height - nutritionProgressView.getLineWidth())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

