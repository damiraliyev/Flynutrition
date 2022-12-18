//
//  AddNewProductViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 18.12.2022.
//

import Foundation
import UIKit

class AddNewProductViewController: UIViewController {
    
    let fieldsStackView = makeStackView(axis: .vertical)
    
    let nameField = LabelTextFieldView(text: "Name of the product")
    
    let caloriesField = LabelTextFieldView(text: "Calories(kC) for 100g")
    
    let proteinsField = LabelTextFieldView(text: "Proteins(g) for 100g")
    
    let fatsField = LabelTextFieldView(text: "Fats(g) for 100g")
    
    let carbsField = LabelTextFieldView(text: "Carbs(g) for 100g")
    
    let addNewProductButton = makeButton(color: .systemBlue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New product"
        
        setup()
        layout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setup() {
        fieldsStackView.spacing = 24
        
        addNewProductButton.setTitle("Add new product", for: .normal)
//        addNewProductButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addNewProductButton.layer.cornerRadius = 5
        addNewProductButton.addTarget(self, action: #selector(addNewProduct), for: .primaryActionTriggered)
        
    }
    
    private func layout() {
        view.addSubview(fieldsStackView)
        
        fieldsStackView.addArrangedSubview(nameField)
        fieldsStackView.addArrangedSubview(caloriesField)
        fieldsStackView.addArrangedSubview(proteinsField)
        fieldsStackView.addArrangedSubview(fatsField)
        fieldsStackView.addArrangedSubview(carbsField)
        
        view.addSubview(addNewProductButton)
        
        NSLayoutConstraint.activate([
            fieldsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            fieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            fieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            addNewProductButton.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 32),
            addNewProductButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewProductButton.widthAnchor.constraint(equalToConstant: 160),
            addNewProductButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func addNewProduct() {
        addNewProductButton.addClickAnimation()
    }
}
