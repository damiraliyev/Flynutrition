//
//  ViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import UIKit


class DayStatisticsViewController: UIViewController {
    
    let todayLabel = makeLabel(withText: "Today")
    
    var calorieProgressView = CircularProgressView()
    var waterProgressView = CircularProgressView()

    
    var dayProgressComponent = DayProgressComponent()
    
    let dayTableView = UITableView()
    
    let recentlyAddedLabel = UILabel()
    
    let addProductButton = makeButton(color: .systemBlue)
    
    
    var consumedProducts: [Product] = [
    ]
    
    var dailyRateCalories = 2000
    var dailyProteinRate = 105
    var dailyFatsRate = 56
    var dailyCarbsRate = 140

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6
        title = "Today"
        setup()
        layout()
        registerForNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    
    
    
    func setup() {
        todayLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
//        todayLabel.attributedText = NSAttributedString(string: todayLabel.text!, attributes: [.kern: 1])
        
        setProgressViews()
        
        setDayProgressComponent()
        
        setTableView()
        
        recentlyAddedLabel.translatesAutoresizingMaskIntoConstraints = false
        recentlyAddedLabel.text = "Recently added"
        recentlyAddedLabel.font = UIFont.systemFont(ofSize: 20)
        recentlyAddedLabel.textColor = .systemGray
    
        addProductButton.layer.cornerRadius = view.bounds.size.width / 16
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold, scale: .medium)
        let configuredImage = UIImage(systemName: "plus", withConfiguration: sizeConfig)
        addProductButton.setImage(configuredImage, for: .normal)
        addProductButton.tintColor = .white
        addProductButton.addTarget(self, action: #selector(addProductPressed), for: .primaryActionTriggered)
    }
    
    func layout() {
//        view.addSubview(todayLabel)
        view.addSubview(dayProgressComponent)
        view.addSubview(recentlyAddedLabel)
        view.addSubview(dayTableView)
        view.addSubview(addProductButton)
        
        
        NSLayoutConstraint.activate([
            dayProgressComponent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dayProgressComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dayProgressComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            recentlyAddedLabel.bottomAnchor.constraint(equalTo: dayTableView.topAnchor, constant: -8),
            recentlyAddedLabel.leadingAnchor.constraint(equalTo: dayTableView.leadingAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            dayTableView.topAnchor.constraint(equalTo: dayProgressComponent.bottomAnchor, constant: 72),
            dayTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dayTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dayTableView.bottomAnchor.constraint(equalTo: addProductButton.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            addProductButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addProductButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addProductButton.widthAnchor.constraint(equalToConstant: view.bounds.size.width / 8),
            addProductButton.heightAnchor.constraint(equalToConstant: view.bounds.size.width / 8),
        ])
    }
    
    func setProgressViews() {
        calorieProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width / 3, height: 120), lineWidth: 7, rounded: false)
        
        waterProgressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width / 3, height: 120), lineWidth: 7, rounded: false)
    }
    
    func setDayProgressComponent() {
        
        dayProgressComponent = DayProgressComponent(circularProgressView: calorieProgressView)
        dayProgressComponent.layer.cornerRadius = 7
    
        dayProgressComponent.translatesAutoresizingMaskIntoConstraints = false
        dayProgressComponent.backgroundColor = .white
        
        dayProgressComponent.caloriesProgressComponent.nutritionProgressView.progress = 0.0
        dayProgressComponent.waterProgressComponent.nutritionProgressView.progress = 0.0
        
        dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text = String(dailyRateCalories)
        
        dayProgressComponent.proteinsProgressBar.combinedAmountLabel.text = "0" + "/" + String(dailyProteinRate) + "g"
        
//        dayProgressComponent.proteinsProgressBar.consumedAmountLabel.tex
        
    }
    
    func setTableView() {
        dayTableView.translatesAutoresizingMaskIntoConstraints = false
        dayTableView.delegate = self
        dayTableView.dataSource = self
        dayTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        dayTableView.register(ConsumedProductCell.self, forCellReuseIdentifier: ConsumedProductCell.reuseID)
        dayTableView.backgroundColor = .clear
        dayTableView.layer.cornerRadius = 10
        dayTableView.rowHeight = 138
    }
    
    @objc func addProductPressed() {
        print("print")
        let addProductsViewController = AddProductsViewController()
        addProductsViewController.navigationController?.navigationItem.searchController = UISearchController()
        navigationController?.pushViewController(addProductsViewController, animated: false)
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(productAdded), name: NSNotification.Name("AddProduct"), object: nil)
    }
    
    @objc func productAdded(_ notification: Notification) {
//        "name": productName ,"amount": amount, "calories": calorieAmount, "proteins": proteins, "fats": fats,
//                           "carbs": carbs
//        let productInfo = notification.userInfo!["product"]
        let name = notification.userInfo?["name"] as! String
        let amount = notification.userInfo?["amount"] as? Int
        let calories = notification.userInfo?["calories"] as? Int
        let proteins = notification.userInfo?["proteins"] as! Float
        let fats = notification.userInfo?["fats"] as! Float
        let carbs = notification.userInfo?["carbs"] as! Float

        
        let newConsumedProduct = Product(name: name, amount: amount ?? 0, calories: calories ?? 0, proteins: proteins, fats: fats, carbs: carbs, measure: .g)
        consumedProducts.append(newConsumedProduct)
        dayTableView.reloadData()
        
        changeCaloriesProgress(newProduct: newConsumedProduct)
        
        calculateRemainedCalories(newProduct: newConsumedProduct)
        
        calculateRemainedProteins(newProduct: newConsumedProduct)
        calculateRemainedFats(newProduct: newConsumedProduct)
        calculateRemainedCarbs(newProduct: newConsumedProduct)
        
    }
    
    func changeCaloriesProgress(newProduct: Product) {
        dayProgressComponent.calorieProgressView.progress += Float(newProduct.calories) / Float(dailyRateCalories)
    }
    
    func calculateRemainedCalories(newProduct: Product) {
        guard let remainText = dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text else { return }
        
        let remainAmountCalorie = (Int(remainText) ?? 0) - Int(newProduct.calories)
        
        if remainAmountCalorie >= 0 {
            dayProgressComponent.caloriesProgressComponent.left1.text = "left"
        } else {
            dayProgressComponent.caloriesProgressComponent.left1.text = "extra"
        }
        
        dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text = String(remainAmountCalorie)
    }
    
    func calculateRemainedProteins(newProduct: Product) {
        dayProgressComponent.proteinsProgressBar.progressBar.progress +=  newProduct.proteins / Float(dailyProteinRate)
        
        let consumedProteinAmount = Float(dayProgressComponent.proteinsProgressBar.consumedAmountLabel.text ?? "0") ?? 0.0
        
        let newProteinsValue = String(format: "%.1f", consumedProteinAmount + newProduct.proteins)

        dayProgressComponent.proteinsProgressBar.consumedAmountLabel.text = newProteinsValue
        dayProgressComponent.proteinsProgressBar.combinedAmountLabel.text = newProteinsValue + "/" + String(dailyProteinRate) + "g"
    }
    
    func calculateRemainedFats(newProduct: Product) {
        dayProgressComponent.fatsProgressBar.progressBar.progress +=  newProduct.fats / Float(dailyFatsRate)
        print(newProduct.fats, "AAA")
        let consumedFatsAmount = Float(dayProgressComponent.carbsProgressBar.consumedAmountLabel.text ?? "0") ?? 0.0
        print(consumedFatsAmount)
        let newFatsValue = String(format: "%.1f", consumedFatsAmount + newProduct.fats)

        dayProgressComponent.fatsProgressBar.consumedAmountLabel.text = newFatsValue
        dayProgressComponent.fatsProgressBar.combinedAmountLabel.text = newFatsValue + "/" + String(dailyFatsRate) + "g"
    }
    
    func calculateRemainedCarbs(newProduct: Product) {
        dayProgressComponent.carbsProgressBar.progressBar.progress +=  newProduct.carbs / Float(dailyCarbsRate)
        
        let consumedCarbsAmount = Float(dayProgressComponent.fatsProgressBar.consumedAmountLabel.text ?? "0") ?? 0.0
        
        let newCarbsValue = String(format: "%.1f", consumedCarbsAmount + newProduct.carbs)

        dayProgressComponent.carbsProgressBar.consumedAmountLabel.text = newCarbsValue
        dayProgressComponent.carbsProgressBar.combinedAmountLabel.text = newCarbsValue + "/" + String(dailyCarbsRate) + "g"
    }
}

extension DayStatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentProduct = consumedProducts[indexPath.row]
            dayProgressComponent.calorieProgressView.progress -= Float(currentProduct.calories) / Float(dailyRateCalories)
            guard let remainText = dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text else { return }
            
            let remainAmountCalorie = (Int(remainText) ?? 0) + currentProduct.calories
            
            if remainAmountCalorie >= 0 {
                dayProgressComponent.caloriesProgressComponent.left1.text = "left"
            } else {
                dayProgressComponent.caloriesProgressComponent.left1.text = "extra"
            }
            
            dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text = String(remainAmountCalorie)
            
            
            consumedProducts.remove(at: indexPath.row)
           
            tableView.reloadData()
            
        }
    }
    
}
extension DayStatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consumedProducts.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConsumedProductCell.reuseID, for: indexPath) as! ConsumedProductCell
        cell.configureConsumedCell(consumedProduct: consumedProducts[indexPath.row])
        return cell
    }
}


