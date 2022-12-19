//
//  StatisticCell.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 19.12.2022.
//

import Foundation
import UIKit

class StatisticCell: UITableViewCell {
    
    static let reuseID = "StatisticCell"
    
    let dateStackView = makeStackView(axis: .vertical)
    let dayLabel = UILabel()
    let monthLabel = UILabel()
    
    
    let nutrientsStackView = makeStackView(axis: .horizontal)
    let proteinNutrientView = NutrientInfo(name: "Proteins", amount: 0, imageName: "Proteins")
    let fatsNutrientView = NutrientInfo(name: "Fats", amount: 0, imageName: "Fats")
    let carbsNutrientView = NutrientInfo(name: "Carbs", amount: 0, imageName: "Carbs")
    
    
    let calorieWaterStackView = makeStackView(axis: .horizontal)
    
    let calorieStackView = makeStackView(axis: .horizontal)
    let caloriesImageView = UIImageView(image: UIImage(named: "Vector.pdf"))
    let caloriesAmountLabel = UILabel()
    
    let waterStackView = makeStackView(axis: .horizontal)
    let waterImageView = UIImageView(image: UIImage(named: "drop.pdf"))
    let waterAmountLabel = UILabel()
    
    let parentStackView = makeStackView(axis: .vertical)
    
//    let amountsStackView = makeStackView(axis: .vertical)
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    
    private func setup() {
        
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        dayLabel.text = String(day)
        dayLabel.font = UIFont.boldSystemFont(ofSize: 25)
        
        monthLabel.text = "Dec"
        monthLabel.font = UIFont.systemFont(ofSize: 18)
        
        nutrientsStackView.distribution = .fillEqually
        nutrientsStackView.spacing = 8
        
        
//        proteinNutrientView.nutrientNameLabel.fo
        
        caloriesAmountLabel.text = "2000kC"
        caloriesAmountLabel.font = UIFont.systemFont(ofSize: 18)
        caloriesImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        caloriesImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        waterAmountLabel.text = "2000ml"
        waterAmountLabel.font = UIFont.systemFont(ofSize: 18)
        waterImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        waterImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        calorieWaterStackView.spacing = 12
        
        calorieStackView.spacing = 5
        waterStackView.spacing = 5
        
        
//        parentStackView.distribution = .fillEqually
    }
    
    
    private func layout() {
        contentView.addSubview(dateStackView)
        
        dateStackView.addArrangedSubview(dayLabel)
        dateStackView.addArrangedSubview(monthLabel)
        
        
        nutrientsStackView.addArrangedSubview(proteinNutrientView)
        nutrientsStackView.addArrangedSubview(fatsNutrientView)
        nutrientsStackView.addArrangedSubview(carbsNutrientView)
        
        
        calorieStackView.addArrangedSubview(caloriesImageView)
        calorieStackView.addArrangedSubview(caloriesAmountLabel)
        
        waterStackView.addArrangedSubview(waterImageView)
        waterStackView.addArrangedSubview(waterAmountLabel)
        
        
        calorieWaterStackView.addArrangedSubview(calorieStackView)
        calorieWaterStackView.addArrangedSubview(waterStackView)
        
        contentView.addSubview(parentStackView)
        parentStackView.addArrangedSubview(calorieWaterStackView)
        parentStackView.addArrangedSubview(nutrientsStackView)
        
        NSLayoutConstraint.activate([
            dateStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        ])
        
        
        
        NSLayoutConstraint.activate([
            parentStackView.centerYAnchor.constraint(equalTo: dateStackView.centerYAnchor),
            parentStackView.leadingAnchor.constraint(equalTo: dateStackView.leadingAnchor, constant: 16),
            parentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
