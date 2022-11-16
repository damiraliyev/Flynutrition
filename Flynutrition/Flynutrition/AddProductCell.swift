//
//  AddProductCell.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit

class AddProductCell: UITableViewCell {
    static let reuseID = "addProductCell"
    
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
        productNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.text = "120g"
        amountLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        calorieImageView.translatesAutoresizingMaskIntoConstraints = false
        calorieImageView.image = UIImage(named: "Vector.pdf")
        calorieImageView.tintColor = .systemGreen
        
        calorieAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        calorieAmountLabel.text = "120kC"
        calorieAmountLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        calorieAmountLabel.textColor = .systemGreen
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 14
        addButton.backgroundColor = .systemBlue
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .medium)
        let configuredImage = UIImage(systemName: "plus", withConfiguration: sizeConfig)
        addButton.setImage(configuredImage, for: .normal)
        addButton.tintColor = .white
        
    
//        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
    
    func layout() {
        contentView.addSubview(productNameLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(calorieImageView)
        contentView.addSubview(calorieAmountLabel)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            productNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 28),
            addButton.heightAnchor.constraint(equalToConstant: 28),
        ])
        
        NSLayoutConstraint.activate([
            calorieAmountLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -16),
            calorieAmountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            calorieImageView.trailingAnchor.constraint(equalTo: calorieAmountLabel.leadingAnchor, constant: -16),
            calorieImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            calorieImageView.widthAnchor.constraint(equalToConstant: 28),
            calorieImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            amountLabel.trailingAnchor.constraint(equalTo: calorieImageView.leadingAnchor, constant: -16),
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProductCell(product: Product) {
        productNameLabel.text = product.name
        calorieAmountLabel.text = String(product.calories)
        amountLabel.text = String(product.amount) + product.measure.rawValue
        
    }

}


