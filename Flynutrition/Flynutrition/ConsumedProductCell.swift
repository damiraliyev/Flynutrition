//
//  ConsumedProductCell.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit

class ConsumedProductCell: UITableViewCell {
    static let reuseID = "consumedProductCell"
    
    let consumedParentStack = makeStackView(axis: .vertical)
    
    let productNameLabel = UILabel()
    let amountLabel = UILabel()
    let calorieImageView = UIImageView()
    let calorieAmountLabel = UILabel()
    let addButton = UIButton()
    
    
    let consumedNutrientStack = makeStackView(axis: .horizontal)
    let proteinsView = NutrientInfo(name: "Proteins", amount: 22)
    let fatsView = NutrientInfo(name: "Fats", amount: 15)
    let carbsView = NutrientInfo(name: "Carbs", amount: 45)
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
        
    }
    
    func setup() {
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.text = "Rice"
        productNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.text = "120g"
        amountLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        calorieImageView.translatesAutoresizingMaskIntoConstraints = false
        calorieImageView.image = UIImage(named: "Vector.pdf")
        calorieImageView.tintColor = .systemGreen
        
        calorieAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        calorieAmountLabel.text = "120kC"
        calorieAmountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        calorieAmountLabel.textColor = .systemGreen
        
      
        consumedNutrientStack.distribution = .fillEqually
        
        proteinsView.translatesAutoresizingMaskIntoConstraints = false
        
        fatsView.translatesAutoresizingMaskIntoConstraints = false
        
        carbsView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        
        
//        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
    
    func layout() {
        
        
        contentView.addSubview(productNameLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(calorieImageView)
        contentView.addSubview(calorieAmountLabel)
        contentView.addSubview(consumedNutrientStack)
        
        consumedNutrientStack.addArrangedSubview(proteinsView)
        consumedNutrientStack.addArrangedSubview(fatsView)
        consumedNutrientStack.addArrangedSubview(carbsView)
        
        NSLayoutConstraint.activate([
            productNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productNameLabel.centerYAnchor.constraint(equalTo: topAnchor, constant: 24)
        ])
        
      
        
        NSLayoutConstraint.activate([
            calorieAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            calorieAmountLabel.centerYAnchor.constraint(equalTo: productNameLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calorieImageView.trailingAnchor.constraint(equalTo: calorieAmountLabel.leadingAnchor, constant: -16),
            calorieImageView.centerYAnchor.constraint(equalTo: productNameLabel.centerYAnchor),
            calorieImageView.widthAnchor.constraint(equalToConstant: 25),
            calorieImageView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: calorieImageView.leadingAnchor, constant: -18),
            amountLabel.centerYAnchor.constraint(equalTo: productNameLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            consumedNutrientStack.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 16),
            consumedNutrientStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            consumedNutrientStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            consumedNutrientStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
//        NSLayoutConstraint.activate([
//            proteinsView.widthAnchor.constraint(equalToConstant: 35),
//            proteinsView.heightAnchor.constraint(equalToConstant: 25),
//            fatsView.widthAnchor.constraint(equalToConstant: 25),
//            fatsView.heightAnchor.constraint(equalToConstant: 25),
//            carbsView.widthAnchor.constraint(equalToConstant: 25),
//            carbsView.heightAnchor.constraint(equalToConstant: 25),
//            
//        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConsumedCell(consumedProduct: Product) {
        productNameLabel.text = consumedProduct.name
        amountLabel.text = String(consumedProduct.amount) + consumedProduct.measure.rawValue
        calorieAmountLabel.text = String(consumedProduct.calories) + "kC"
    }
}

