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
    var dailyWaterRate = 2000
    var dailyProteinRate = 105
    var dailyFatsRate = 56
    var dailyCarbsRate = 140
    
    //Max for progress bar is 1, but the sum of all products can be more than this
    //Problem will occur when we will start to delete products
    var progressBarProteinTracker: Float = 0
    var progressBarFatsTracker: Float = 0
    var progressBarCarbsTracker: Float = 0
    
    
    enum Nutrients {
        case proteins
        case fats
        case carbs
    }
    
    enum Operations {
        case add
        case delete
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor(red: 0.94902, green: 0.94902, blue: 0.968627, alpha: 1)
        view.backgroundColor = .systemGray6
        
        print(UIColor.systemGray6.cgColor)
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
        
        dayProgressComponent.waterProgressComponent.elementRemainLabel.text = String(dailyWaterRate)
        
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
        let addProductsViewController = AddProductsViewController()
        addProductsViewController.navigationController?.navigationItem.searchController = UISearchController()
        navigationController?.pushViewController(addProductsViewController, animated: false)
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(productAdded), name: NSNotification.Name("AddProduct"), object: nil)
    }
    
    @objc func productAdded(_ notification: Notification) {
        let name = notification.userInfo?["name"] as! String
        let amount = notification.userInfo?["amount"] as? Int
        let calories = notification.userInfo?["calories"] as? Int
        let proteins = notification.userInfo?["proteins"] as! Float
        let fats = notification.userInfo?["fats"] as! Float
        let carbs = notification.userInfo?["carbs"] as! Float
        let measure = notification.userInfo?["measure"] as! Measure
        
        let newConsumedProduct = Product(name: name, amount: amount ?? 0, calories: calories ?? 0, proteins: proteins, fats: fats, carbs: carbs, measure: measure)
        consumedProducts.insert(newConsumedProduct, at: 0)
        dayTableView.reloadData()
        
        if newConsumedProduct.name.lowercased() == "water" {
              calculateRemainedCalorieOrWater(newProduct: newConsumedProduct)
              changeWaterProgress(newProduct: newConsumedProduct)
        } else {
            changeCaloriesProgress(newProduct: newConsumedProduct)

            calculateRemainedCalorieOrWater(newProduct: newConsumedProduct)
            
            calculateRemainedProteinsProgressBar(newProduct: newConsumedProduct)
            calculateRemainedFatsProgressBar(newProduct: newConsumedProduct)
            calculateRemainedCarbsProgressBar(newProduct: newConsumedProduct)
        }
        
        
        
    }
    
    func changeCaloriesProgress(newProduct: Product) {
        dayProgressComponent.calorieProgressView.progress += Float(newProduct.calories) / Float(dailyRateCalories)
    }
    
    func changeWaterProgress(newProduct: Product) {
        dayProgressComponent.waterProgressView.progress += Float(newProduct.amount) / Float(dailyWaterRate)
    }

    func calculateRemainedCalorieOrWater(newProduct: Product) {
        var progressComponent = dayProgressComponent.caloriesProgressComponent
        var neededMeasure = newProduct.calories
        var textAfterReaching = "extra"
        if newProduct.name.lowercased() == "water" {
            progressComponent = dayProgressComponent.waterProgressComponent
            neededMeasure = newProduct.amount
            textAfterReaching = ""
        }
        guard let remainText = progressComponent.elementRemainLabel.text else { return }
        
        let remainedAmount = (Int(remainText) ?? 0) - Int(neededMeasure)

        if remainedAmount >= 0 {
            progressComponent.left1.text = "left"
        } else {
            progressComponent.left1.text = textAfterReaching
        }
        
        progressComponent.elementRemainLabel.text = String(remainedAmount)

        
    }
    
    func calculateRemainedProteinsProgressBar(newProduct: Product) {
        dayProgressComponent.proteinsProgressBar.progressBar.progress += round(newProduct.proteins / Float(dailyProteinRate) * 10000) / 10000
        
        progressBarProteinTracker += round(newProduct.proteins / Float(dailyProteinRate) * 10000) / 10000
  
        recalculateNutrients(currentProduct: newProduct, operation: .add, nutrient: .proteins)
    }
    
    func calculateRemainedFatsProgressBar(newProduct: Product) {
        dayProgressComponent.fatsProgressBar.progressBar.progress += round(newProduct.fats / Float(dailyFatsRate) * 10000) / 10000
        
        progressBarFatsTracker += round(newProduct.fats / Float(dailyFatsRate) * 10000) / 10000
 
        recalculateNutrients(currentProduct: newProduct, operation: .add, nutrient: .fats)
    }
    
    func calculateRemainedCarbsProgressBar(newProduct: Product) {
        dayProgressComponent.carbsProgressBar.progressBar.progress += round(newProduct.carbs / Float(dailyCarbsRate) * 10000) / 10000
        
        progressBarCarbsTracker += round(newProduct.carbs / Float(dailyCarbsRate) * 10000) / 10000

        recalculateNutrients(currentProduct: newProduct, operation: .add, nutrient: .carbs)
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
            
            dayProgressComponent.waterProgressView.progress -= Float(currentProduct.amount) / Float(dailyWaterRate)
            
           recalculateProgressAfterDeleting(currentProduct: currentProduct)
            
           
            guard let remainText = dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text else { return }
            
            guard let remainTextWater = dayProgressComponent.waterProgressComponent.elementRemainLabel.text else { return }
            
            let remainAmountCalorie = (Int(remainText) ?? 0) + currentProduct.calories
            let remainAmountWater = (Int(remainTextWater) ?? 0) + currentProduct.amount
            
            changeTextBasedOnRemainder(remainAmount: remainAmountCalorie, isWater: false)
            changeTextBasedOnRemainder(remainAmount: remainAmountWater, isWater: true)
            
            dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text = String(remainAmountCalorie)
            dayProgressComponent.waterProgressComponent.elementRemainLabel.text = String(remainAmountWater)
            
            consumedProducts.remove(at: indexPath.row)
           
            tableView.reloadData()
            
        }
    }
    
    func changeTextBasedOnRemainder(remainAmount: Int, isWater: Bool) {
        var textAfterReaching: String
        var component: NutrientCircularProgressView = dayProgressComponent.caloriesProgressComponent
        
        if isWater {
            textAfterReaching = ""
            component = dayProgressComponent.waterProgressComponent
        }
        else {
            textAfterReaching = "extra"
        }
        
        if remainAmount >= 0{
            component.left1.text = "left"
        } else {
            component.left1.text = textAfterReaching
        }
        
    }
    
    func recalculateProgressAfterDeleting(currentProduct: Product) {
        progressBarProteinTracker -= round(Float(currentProduct.proteins) / Float(dailyProteinRate) * 10000) / 10000
        recalculateNutrients(currentProduct: currentProduct, operation: .delete, nutrient: .proteins)
        if progressBarProteinTracker <= 1 && consumedProducts.count > 1{
            dayProgressComponent.proteinsProgressBar.progressBar.progress -= round(Float(currentProduct.proteins) / Float(dailyProteinRate) * 10000) / 10000
            
        } else if progressBarProteinTracker < 0 || consumedProducts.count == 1 {
            progressBarProteinTracker = 0
            dayProgressComponent.proteinsProgressBar.progressBar.progress = 0
        }
        
        progressBarFatsTracker -= round(Float(currentProduct.fats) / Float(dailyFatsRate) * 10000) / 10000
        recalculateNutrients(currentProduct: currentProduct, operation: .delete, nutrient: .fats)
        if progressBarFatsTracker <= 1 && consumedProducts.count > 1{
            dayProgressComponent.fatsProgressBar.progressBar.progress -= round(Float(currentProduct.fats) / Float(dailyFatsRate) * 10000) / 10000

        } else if progressBarFatsTracker < 0 || consumedProducts.count == 1 {
            progressBarFatsTracker = 0
            dayProgressComponent.fatsProgressBar.progressBar.progress = 0
        }
        

        progressBarCarbsTracker -= round(Float(currentProduct.carbs) / Float(dailyCarbsRate) * 10000) / 10000
        recalculateNutrients(currentProduct: currentProduct, operation: .delete, nutrient: .carbs)
        if progressBarCarbsTracker <= 1 && consumedProducts.count > 1{
            dayProgressComponent.carbsProgressBar.progressBar.progress -= round(Float(currentProduct.carbs) / Float(dailyCarbsRate) * 10000) / 10000
        } else if progressBarCarbsTracker < 0 || consumedProducts.count == 1 {
            progressBarCarbsTracker = 0
            dayProgressComponent.carbsProgressBar.progressBar.progress = 0
        }
        
    }
    
    
    func recalculateNutrients(currentProduct: Product, operation: Operations, nutrient: Nutrients) {
        var consumedNutrientAmountBar: NutrientProgressBarView
        var consumedNutrientAmount: Float
        var newValue: String
        var productNutrient: Float
        var dailyRate: Int
        
        switch nutrient {
        case .proteins:
            consumedNutrientAmountBar = dayProgressComponent.proteinsProgressBar
            consumedNutrientAmount =  Float(consumedNutrientAmountBar.consumedAmountLabel.text ?? "0") ?? 0.0
            productNutrient = currentProduct.proteins
            dailyRate = dailyProteinRate
        case .fats:
            consumedNutrientAmountBar = dayProgressComponent.fatsProgressBar
            consumedNutrientAmount = Float(consumedNutrientAmountBar.consumedAmountLabel.text ?? "0") ?? 0.0
            productNutrient = currentProduct.fats
            dailyRate = dailyFatsRate
        case .carbs:
            consumedNutrientAmountBar = dayProgressComponent.carbsProgressBar
            consumedNutrientAmount = Float(consumedNutrientAmountBar.consumedAmountLabel.text ?? "0") ?? 0.0
            productNutrient = currentProduct.carbs
            dailyRate = dailyCarbsRate
        }
        
        if operation == .add {
            newValue = String(format: "%.1f", consumedNutrientAmount + productNutrient)
        } else {
            newValue = String(format: "%.1f", consumedNutrientAmount - productNutrient)
        }
        
        consumedNutrientAmountBar.consumedAmountLabel.text = newValue
        consumedNutrientAmountBar.combinedAmountLabel.text = newValue + "/" + String(dailyRate) + "g"
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
