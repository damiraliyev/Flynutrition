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
    var proteins = NutrientInfo(name: "Proteins", amount: 20, imageName: "Proteins.pdf")
    let fats = NutrientInfo(name: "Fats", amount: 18, imageName: "Fats.pdf")
    let carbs = NutrientInfo(name: "Carbs", amount: 50, imageName: "Carbs.pdf")
    
    
    let massLabel = UILabel()
    var measure: Measure = .g
    
    
    let amountTextField = UITextField()
    let lineView = UIView()
    
    let addButton = makeButton(color: .systemBlue)
    
    var amount: Int = 0
   
    var caloriesAmount: Int = 0
    var proteinsAmount: Float = 0
    var fatsAmount: Float = 0
    var carbsAmount: Float = 0
    
    var initialCalories: Int = 0
    var initialProteins: Float = 0
    var initialFats: Float = 0
    var initialCarbs: Float = 0
    
    let errorLabel = UILabel()
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
        
        massLabel.text = massLabel.text! + "(\(measure.rawValue))"
        
        
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.backgroundColor = .clear
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .systemGray
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textColor = .systemRed
        errorLabel.isHidden = true
        errorLabel.font = UIFont.systemFont(ofSize: 15)
        
        addButton.setTitle("Add", for: .normal)
        addButton.titleLabel?.textColor = .white
        addButton.layer.cornerRadius = 10
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        addButton.addTarget(self, action: #selector(addWithChangedValue), for: .primaryActionTriggered)
        
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
        view.addSubview(errorLabel)
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
            errorLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
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
        calorieAmountLabel.text = String(product.calories) + "kC"
        proteins.amountLabel.text = String(product.proteins) + "g"
        fats.amountLabel.text = String(product.fats) + "g"
        carbs.amountLabel.text = String(product.carbs) + "g"
        measure = product.measure
        
        caloriesAmount = product.calories
        proteinsAmount = product.proteins
        fatsAmount = product.fats
        carbsAmount = product.carbs
        
        initialCalories = Int(calorieAmountLabel.text!.dropLast(2))!
        initialProteins = proteinsAmount
        initialFats = fatsAmount
        initialCarbs = carbsAmount
    }
    
    
    @objc func addWithChangedValue(_ sender: UIButton) {
        sender.alpha = 0.3
        
        UIView.animate(withDuration: 0.5, delay: 0) {
            sender.alpha = 1
        }
        
        if amountTextField.text == "0" {
            return
        }
        

        let productCalorieWithoutMeasure = String(calorieAmountLabel.text?.replacingOccurrences(of: " ", with: "").dropLast(2)  ?? "").replacingOccurrences(of: "\u{fffc}", with: "")
       
        let productInfo = ["name": productName ,"amount": Int(amountTextField.text!) ?? 100, "calories": Int(productCalorieWithoutMeasure) ?? 0, "proteins": proteinsAmount, "fats": fatsAmount, "carbs": carbsAmount, "measure": measure
                               
        ] as [String : Any]
        
        NotificationCenter.default.post(name: Notification.Name("AddProduct"), object: nil, userInfo: productInfo)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}


extension ProductInfoViewController: UITextFieldDelegate {
   
    @objc func textFieldEditingChanged(_ sender: UITextField) {
        //Change the amount if value was changed
        //Decided to put amountTextField.text value instead of amount, because intially there was the first one
        // And initally amountTextField.text will be displayed and I decided leave it it like this
        amount = Int(sender.text ?? "") ?? 0
        amountTextField.text = String(amount)
        print("Amount", amount)
        print(Int(sender.text ?? ""))
        
        caloriesAmount = (amount * initialCalories) / 100
        proteinsAmount = round((Float(amount) * initialProteins) / 100 * 10) / 10
        fatsAmount = round((Float(amount) * initialFats) / 100 * 10) / 10
        carbsAmount = round((Float(amount) * initialCarbs) / 100 * 10) / 10
        
        calorieAmountLabel.text = String(caloriesAmount) + "kC"
        setCalorieLabel()
        
        proteins.amountLabel.text = String(proteinsAmount) + "g"
        fats.amountLabel.text = String(fatsAmount) + "g"
        carbs.amountLabel.text = String(carbsAmount) + "g"
    }
    
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: textField.text ?? "")) {
//
//            errorLabel.text = ""
//            errorLabel.isHidden = true
//            return true
//        } else {
//            errorLabel.text = "Text field can contain only numbers."
//            errorLabel.isHidden = false
//            
//            return false
//        }
//       
//    }

}
