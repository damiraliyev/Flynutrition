//
//  ProductInfroViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 16.11.2022.
//

import Foundation
import UIKit

class ProductInfoViewController: UIViewController {
    
    let parentStack = makeStackView(axis: .vertical)
    
    let caloriesImageView = UIImageView()
    
    let calorieAmountLabel = UILabel()
    
    var productName = String()
    
    let nutrientsStack = makeStackView(axis: .horizontal)
    let proteins = NutrientInfo(name: "Proteins", amount: 20, imageName: "Proteins.pdf")
    let fats = NutrientInfo(name: "Fats", amount: 18, imageName: "Fats.pdf")
    let carbs = NutrientInfo(name: "Carbs", amount: 50, imageName: "Carbs.pdf")
    
    
    let massLabel = UILabel()
    var measure = String()
    
    
    let amountTextField = UITextField()
    let lineView = UIView()
    
    let addButton = makeButton(color: .systemBlue)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = productName
        
        view.backgroundColor = .systemGray6
        setup()
        layout()
    }
    
    func setup() {
        
        setParentStack()
        
        calorieAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setCalorieLabel()
        
        nutrientsStack.distribution = .fillEqually
        nutrientsStack.spacing = 50
        
        proteins.translatesAutoresizingMaskIntoConstraints = false
        
        fats.translatesAutoresizingMaskIntoConstraints = false
        
        carbs.translatesAutoresizingMaskIntoConstraints = false
        
        massLabel.translatesAutoresizingMaskIntoConstraints = false
        massLabel.font = UIFont.systemFont(ofSize: 17)
        massLabel.textColor = .systemGray
        massLabel.text = "Mass"
        
        
//        measure = "g"
        
        massLabel.text = massLabel.text! + "(\(measure))"
        
        
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.backgroundColor = .clear
        
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .systemGray
        
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.textColor = .white
        addButton.layer.cornerRadius = 10
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
    }
    
    func layout() {
        view.addSubview(parentStack)
        parentStack.addArrangedSubview(calorieAmountLabel)
        parentStack.addArrangedSubview(nutrientsStack)
       
        
        nutrientsStack.addArrangedSubview(proteins)
        nutrientsStack.addArrangedSubview(fats)
        nutrientsStack.addArrangedSubview(carbs)
        
        view.addSubview(massLabel)
        view.addSubview(amountTextField)
        view.addSubview(lineView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            parentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            parentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            parentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            massLabel.topAnchor.constraint(equalTo: parentStack.bottomAnchor, constant: 32),
            massLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: massLabel.bottomAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: amountTextField.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: amountTextField.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: amountTextField.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 24),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
    func setParentStack() {
        parentStack.layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
        parentStack.isLayoutMarginsRelativeArrangement = true
        parentStack.layer.cornerRadius = 10
        parentStack.backgroundColor = .white
        parentStack.alignment = .center
        parentStack.spacing = 30
        
    }
    
    func setCalorieLabel() {
//        calorieAmountLabel.text = "250kC"
        calorieAmountLabel.textColor = .systemGreen
        calorieAmountLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: "")

        // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "Vector.pdf")

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        fullString.append(image1String)
        fullString.append(NSAttributedString(string: "  "))
        fullString.append(NSAttributedString(string: calorieAmountLabel.text ?? ""))

        calorieAmountLabel.attributedText = fullString
        
    }
    
    func configureProductInfo(product: Product) {
       productName = product.name
       amountTextField.text = String(product.amount)
        calorieAmountLabel.text = String(product.calories) + product.measure.rawValue
        proteins.amountLabel.text = String(product.proteins) + "г"
        fats.amountLabel.text = String(product.fats) + "г"
        carbs.amountLabel.text = String(product.carbs) + "г"
        measure = product.measure.rawValue
    }
}
