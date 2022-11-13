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
    
    let productNameLabel = UILabel()
    let amountLabel = UILabel()
    let calorieImageView = UIImageView()
    let calorieAmountLabel = UILabel()
    let addButton = UIButton()
        
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
        calorieImageView.image = UIImage(systemName: "flame.fill")
        calorieImageView.tintColor = .systemGreen
        
        calorieAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        calorieAmountLabel.text = "120kC"
        calorieAmountLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        calorieAmountLabel.textColor = .systemGreen
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 17.5
        addButton.backgroundColor = .systemBlue
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.textAlignment = .center
        addButton.titleLabel?.textColor = .white
        
//        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
    
    func layout() {
        contentView.addSubview(productNameLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(calorieImageView)
        contentView.addSubview(calorieAmountLabel)
        
        NSLayoutConstraint.activate([
            productNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
      
        
        NSLayoutConstraint.activate([
            calorieAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            calorieAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calorieImageView.trailingAnchor.constraint(equalTo: calorieAmountLabel.leadingAnchor, constant: -16),
            calorieImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            calorieImageView.widthAnchor.constraint(equalToConstant: 30),
            calorieImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: calorieImageView.leadingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

