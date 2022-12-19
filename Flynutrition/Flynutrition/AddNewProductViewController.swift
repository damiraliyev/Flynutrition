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
    
    let errorLabel = UILabel()
    
    
    let measureStack = makeStackView(axis: .horizontal)
    
    let measureSegmentedControl = UISegmentedControl()
    let measures = [Measure.g, Measure.ml]
    
    let measureTipLabel = makeLabel(withText: "Choose the measure:")
    
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
        
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .red
        errorLabel.isHidden = true
        
        
        measureStack.spacing = 10
        
        measureSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        measureSegmentedControl.insertSegment(withTitle: "g", at: 0, animated: true)
        measureSegmentedControl.insertSegment(withTitle: "ml", at: 1, animated:    true)
        measureSegmentedControl.selectedSegmentIndex = 0
        
        measureTipLabel.alpha = 0.5
        
    }
    
    private func layout() {
        view.addSubview(fieldsStackView)
        
        fieldsStackView.addArrangedSubview(nameField)
        fieldsStackView.addArrangedSubview(caloriesField)
        fieldsStackView.addArrangedSubview(proteinsField)
        fieldsStackView.addArrangedSubview(fatsField)
        fieldsStackView.addArrangedSubview(carbsField)
        
        
        view.addSubview(measureStack)
        measureStack.addArrangedSubview(measureTipLabel)
        measureStack.addArrangedSubview(measureSegmentedControl)
        
        view.addSubview(errorLabel)
        view.addSubview(addNewProductButton)
        
        NSLayoutConstraint.activate([
            fieldsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            fieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            fieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            measureStack.topAnchor.constraint(equalTo: fieldsStackView.bottomAnchor, constant: 32),
            measureStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            measureSegmentedControl.widthAnchor.constraint(equalToConstant: 100),
            measureSegmentedControl.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: measureStack.bottomAnchor, constant: 24),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addNewProductButton.topAnchor.constraint(equalTo: measureStack.bottomAnchor, constant: 64),
            addNewProductButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addNewProductButton.widthAnchor.constraint(equalToConstant: 160),
            addNewProductButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func addNewProduct() {
        addNewProductButton.addClickAnimation()
        errorLabel.isHidden = true
        
        var errorOccured = false
        if nameField.textField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please, write the name of a product"
            return
        }
        
        errorOccured = showErrorLabel(field: caloriesField, nutrientName: "calories")
        
        if errorOccured {
            return
        }
        errorOccured = showErrorLabel(field: proteinsField, nutrientName: "proteins")
        if errorOccured {
            return
        }
        errorOccured = showErrorLabel(field: fatsField, nutrientName: "fats")
        if errorOccured {
            return
        }
        errorOccured = showErrorLabel(field: carbsField, nutrientName: "carbs")
        if errorOccured {
            return
        }
        
        let product = Product(name: nameField.textField.text!, amount: 100, calories: Int(caloriesField.textField.text!)!, proteins: Float(proteinsField.textField.text!)!, fats: Float(fatsField.textField.text!)!, carbs: Float(carbsField.textField.text!)!, measure: measures[measureSegmentedControl.selectedSegmentIndex])
        
        
        
        NotificationCenter.default.post(name: newProductAdded, object: nil, userInfo: ["product": product])
        
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func showErrorLabel(field: LabelTextFieldView, nutrientName: String) -> Bool {
        
        if field.textField.text! == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Please, write the \(nutrientName) amount"
            return true
        }
        
        if Int(field.textField.text!) == nil {
            errorLabel.isHidden = false
            errorLabel.text = "Please, write correct value to \(nutrientName) field"
            return true
        }
        
        return false
    }
}
