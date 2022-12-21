//
//  ViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import UIKit
import CoreData


protocol StatisticsDelegate: AnyObject {
    func dateChanged(statistics: DailyStatistics)
}

class DayStatisticsViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let todayLabel = makeLabel(withText: "Today")
    
    var calorieProgressView = CircularProgressView()
    var waterProgressView = CircularProgressView()

    
    var dayProgressComponent = DayProgressComponent()
    
    let dayTableView = UITableView()
    
    let recentlyAddedLabel = UILabel()
    
    let addProductButton = makeButton(color: .systemBlue)
    
    
    var consumedProducts: [ConsumedProduct] = [
    ]
    
    var weight: Double = LocalState.weight
    var dailyRateCalories = 2300
    var dailyWaterRate = 2000
    var dailyProteinRate = 105
    var dailyFatsRate = 63
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
    
    //Delegate
    weak var statisticsDelegate: StatisticsDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        print(UIColor.systemGray6.cgColor)
        title = "Today"

       
        loadProducts()
        setup()
        
        adjustNutrientsAccrordingToSettings()
        
        layout()
        registerForNotifications()
        calculateResultAfterFetching()
        checkDate()
        
       

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
//        calculateResultAfterFetching()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    //Accordint to mode
    // We did this because we need to store and adjust it according to settings
    func adjustNutrientsAccrordingToSettings() {
        if LocalState.mode == 0 {
            dailyProteinRate = Int(LocalState.weight * (activeModeMeasures["proteins"] ?? 0))
            dailyFatsRate = Int(LocalState.weight * (activeModeMeasures["fats"] ?? 0))
            dailyCarbsRate = Int(LocalState.weight * (activeModeMeasures["carbs"] ?? 0))
        } else {
            dailyProteinRate = Int(LocalState.weight * (passiveModeMeasures["proteins"] ?? 0))
            dailyFatsRate = Int(LocalState.weight * (passiveModeMeasures["fats"] ?? 0))
            dailyCarbsRate = Int(LocalState.weight * (passiveModeMeasures["carbs"] ?? 0))
        }
        
        dayProgressComponent.proteinsProgressBar.combinedAmountLabel.text =  "0" + "/" + String(dailyProteinRate) + "g"
        dayProgressComponent.fatsProgressBar.combinedAmountLabel.text = "0" + "/" + String(dailyFatsRate) + "g"
        dayProgressComponent.carbsProgressBar.combinedAmountLabel.text = "0" + "/" + String(dailyCarbsRate) + "g"
        
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
        
        dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text = String(dailyRateCalories) + "kC"
        
        dayProgressComponent.waterProgressComponent.elementRemainLabel.text = String(dailyWaterRate) + "ml"
        
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
        let addProductsViewController = ProductListViewController()
        addProductsViewController.navigationController?.navigationItem.searchController = UISearchController()
        navigationController?.pushViewController(addProductsViewController, animated: false)
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(productAdded), name: NSNotification.Name("AddProduct"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeMode), name: modeChanged, object: nil)
    }
    
    @objc func productAdded(_ notification: Notification) {
        let name = notification.userInfo?["name"] as! String
        let amount = notification.userInfo?["amount"] as? Int
        let calories = notification.userInfo?["calories"] as? Int
        let proteins = notification.userInfo?["proteins"] as! Float
        let fats = notification.userInfo?["fats"] as! Float
        let carbs = notification.userInfo?["carbs"] as! Float
        let measure = notification.userInfo?["measure"] as! String
        
        let newConsumedProduct = ConsumedProduct(context: context)
        newConsumedProduct.name = name
        newConsumedProduct.amount = Int32(amount ?? 0)
        newConsumedProduct.calories = Int32(calories ?? 0)
        newConsumedProduct.proteins = proteins
        newConsumedProduct.fats = fats
        newConsumedProduct.carbs = carbs
        newConsumedProduct.measure = measure
        
        consumedProducts.insert(newConsumedProduct, at: 0)
        saveConsumedProduct()
        
        
        if newConsumedProduct.name?.lowercased() == "water" {
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
    
   
    
    @objc func changeMode(_ notification: Notification) {
        
        LocalState.weight = notification.userInfo?["weight"] as! Double
        print(LocalState.weight)
        
        weight = LocalState.weight
         
        if notification.userInfo?["proteins"] as! Double == 1.5 {
            LocalState.mode = 0
        } else {
            LocalState.mode = 1
            print("LocalState to 1")
        }
        
        print(notification.userInfo?["proteins"] as! Double)
        
        dailyProteinRate = Int(notification.userInfo?["proteins"] as! Double * weight)
        dailyFatsRate = Int(notification.userInfo?["fats"] as! Double * weight)
        dailyCarbsRate = Int(notification.userInfo?["carbs"] as! Double * weight)
        
        print(dailyProteinRate)
       
        
        adjustProgressToModeChanging()
      
    }
    
    func adjustProgressToModeChanging() {
        dayProgressComponent.proteinsProgressBar.combinedAmountLabel.text = (dayProgressComponent.proteinsProgressBar.consumedAmountLabel.text ?? "0") + "/" + String(dailyProteinRate) + "g"
        dayProgressComponent.fatsProgressBar.combinedAmountLabel.text = (dayProgressComponent.fatsProgressBar.consumedAmountLabel.text ?? "0") + "/" + String(dailyFatsRate) + "g"
        
        dayProgressComponent.carbsProgressBar.combinedAmountLabel.text = (dayProgressComponent.carbsProgressBar.consumedAmountLabel.text ?? "0") + "/" + String(dailyCarbsRate) + "g"
        
        
        let alreadyConsumedProteins = Float(dayProgressComponent.proteinsProgressBar.consumedAmountLabel.text ?? "0")!
        dayProgressComponent.proteinsProgressBar.progressBar.progress = round(alreadyConsumedProteins / Float(dailyProteinRate) * 10000) / 10000
        
        let alreadyConsumedFats = Float(dayProgressComponent.fatsProgressBar.consumedAmountLabel.text ?? "0")!
        dayProgressComponent.fatsProgressBar.progressBar.progress = round(alreadyConsumedFats / Float(dailyFatsRate) * 10000) / 10000
        
        let alreadyConsumedCarbs = Float(dayProgressComponent.carbsProgressBar.consumedAmountLabel.text ?? "0")!
        dayProgressComponent.carbsProgressBar.progressBar.progress = round(alreadyConsumedCarbs / Float(dailyCarbsRate) * 10000) / 10000
        
    }
    
    func changeCaloriesProgress(newProduct: ConsumedProduct) {
        dayProgressComponent.calorieProgressView.progress += Float(newProduct.calories) / Float(dailyRateCalories)
    }
    
    func changeWaterProgress(newProduct: ConsumedProduct) {
        dayProgressComponent.waterProgressView.progress += Float(newProduct.amount) / Float(dailyWaterRate)
    }
    
    
    //Calculate when product is added
    //Calories and Water

    func calculateRemainedCalorieOrWater(newProduct: ConsumedProduct) {
        print("CalculateRemainedCalorieOrWater")
        var progressComponent = dayProgressComponent.caloriesProgressComponent
        var measure = "kC"
       
        var addedAmount = newProduct.calories
        var textAfterReaching = "extra"
        if newProduct.name?.lowercased() == "water" {
            progressComponent = dayProgressComponent.waterProgressComponent
            addedAmount = newProduct.amount
            measure = "ml"
            textAfterReaching = ""
        }
        guard let remainText = progressComponent.elementRemainLabel.text?.dropLast(2) else { return }
        
        let remainedAmount = (Int(remainText) ?? 0) - Int(addedAmount)

        if remainedAmount >= 0 {
            progressComponent.left1.text = "left"
        } else {
            progressComponent.left1.text = textAfterReaching
        }
        
        progressComponent.elementRemainLabel.text = String(remainedAmount) + measure

        
    }
    
    func calculateRemainedProteinsProgressBar(newProduct: ConsumedProduct) {
        print("calculateRemainedProteinsProgressBar")
        dayProgressComponent.proteinsProgressBar.progressBar.progress += round(newProduct.proteins / Float(dailyProteinRate) * 10000) / 10000
        
        progressBarProteinTracker += round(newProduct.proteins / Float(dailyProteinRate) * 10000) / 10000
  
        recalculateNutrients(currentProduct: newProduct, operation: .add, nutrient: .proteins)
    }
    
    func calculateRemainedFatsProgressBar(newProduct: ConsumedProduct) {
        print("calculateRemainedFatsProgressBar")
        dayProgressComponent.fatsProgressBar.progressBar.progress += round(newProduct.fats / Float(dailyFatsRate) * 10000) / 10000
        
        progressBarFatsTracker += round(newProduct.fats / Float(dailyFatsRate) * 10000) / 10000
 
        recalculateNutrients(currentProduct: newProduct, operation: .add, nutrient: .fats)
    }
    
    func calculateRemainedCarbsProgressBar(newProduct: ConsumedProduct) {
        print("calculateRemainedCarbsProgressBar")
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
            
            processAfterDeletingConsumedProduct(index: indexPath.row)

        }
    }
    
    func changeTextBasedOnRemainder(remainAmount: Int32, isWater: Bool) {
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
    
    func recalculateProgressAfterDeleting(currentProduct: ConsumedProduct) {
        
        print("Product was deleted and nutrients will be recalculated")
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
    
    
    func recalculateNutrients(currentProduct: ConsumedProduct, operation: Operations, nutrient: Nutrients) {
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


//MARK: - CoreData functions

extension DayStatisticsViewController {
    func calculateProductAfterFetching(product: ConsumedProduct) {
        if product.name?.lowercased() == "water" {
              calculateRemainedCalorieOrWater(newProduct: product)
              changeWaterProgress(newProduct: product)
        } else {
            changeCaloriesProgress(newProduct: product)

            calculateRemainedCalorieOrWater(newProduct: product)
            
            calculateRemainedProteinsProgressBar(newProduct: product)
            calculateRemainedFatsProgressBar(newProduct: product)
            calculateRemainedCarbsProgressBar(newProduct: product)
        }
    }
    
    func saveConsumedProduct() {
        do {
            try context.save()
        } catch {
            print("Error occured while saving context: \(error)")
        }
        
        dayTableView.reloadData()
    }
    
    func loadProducts() {
        let request: NSFetchRequest<ConsumedProduct> = ConsumedProduct.fetchRequest()
        
        do {
            consumedProducts = try context.fetch(request)
            consumedProducts = consumedProducts.reversed()
        } catch {
            print("Error occured while loading context: \(error)")
        }
    }
    
    func calculateResultAfterFetching() {
        
        for product in consumedProducts {
            calculateProductAfterFetching(product: product)
        }
    }
}



//MARK: - Checking date
extension DayStatisticsViewController{
   
    
    func checkDate() {
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)

        
//
//        let statisticsModel = DailyStatistic(day: day - 1, month: month, calories: consumedCaloriesForDay, water: consumedWaterForDay, proteins: consumedProteinsForDay, fats: consumedFatsForDay, carbs: consumedCarbsForDay)
//
//        let testDay = 19
//        let testMonth = 12
        print(LocalState.day)
        if LocalState.day != 22 || (LocalState.day == day && LocalState.month != month){
            
            
            let consumedCaloriesForDay = dailyRateCalories - (Int(dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text?.dropLast(2) ?? "0") ?? 0)
           print("Consumed:", Int(dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text?.dropLast(2) ?? "0") ?? 0)
            let consumedWaterForDay = dailyWaterRate - (Int(dayProgressComponent.waterProgressComponent.elementRemainLabel.text?.dropLast(2) ?? "0") ?? 0)
           
            let consumedProteinsForDay = Float(dayProgressComponent.proteinsProgressBar.consumedAmountLabel.text ?? "0") ?? 0
            
            let consumedFatsForDay = Float(dayProgressComponent.fatsProgressBar.consumedAmountLabel.text ?? "0") ?? 0
            
            let consumedCarbsForDay = Float(dayProgressComponent.carbsProgressBar.consumedAmountLabel.text ?? "0") ?? 0

            
            let statisticsModel = DailyStatistics(context: context)
            statisticsModel.day = Int32(LocalState.day)
            statisticsModel.month = Int32(month)
            statisticsModel.calories = Int32(consumedCaloriesForDay)
            statisticsModel.water = Int32(consumedWaterForDay)
            statisticsModel.proteins = consumedProteinsForDay
            statisticsModel.fats = consumedFatsForDay
            statisticsModel.carbs = consumedCarbsForDay

            statisticsDelegate?.dateChanged(statistics: statisticsModel)
            var i = consumedProducts.count - 1
            
            while consumedProducts.count != 0 {
                processAfterDeletingConsumedProduct(index: i)
                i -= 1

            }
            
            LocalState.day = day
            LocalState.month = month
            
        }
    }
    
    func processAfterDeletingConsumedProduct(index i: Int) {
        let currentProduct = consumedProducts[i]
       
        if currentProduct.name?.lowercased() == "water" {
            
            guard let remainTextWater = dayProgressComponent.waterProgressComponent.elementRemainLabel.text?.dropLast(2) else { return }
            dayProgressComponent.waterProgressView.progress -= Float(currentProduct.amount) / Float(dailyWaterRate)
            
            let remainAmountWater = (Int32(remainTextWater) ?? 0) + currentProduct.amount
            changeTextBasedOnRemainder(remainAmount: remainAmountWater, isWater: true)
            dayProgressComponent.waterProgressComponent.elementRemainLabel.text = String(remainAmountWater) + "ml"
            print("Accidentally delete ")
            
        } else {
            dayProgressComponent.calorieProgressView.progress -= Float(currentProduct.calories) / Float(dailyRateCalories)
            guard let remainText = dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text?.dropLast(2) else { return }
            
           
            print("RemainText", remainText)
            let remainAmountCalorie = (Int32(remainText) ?? 0) + currentProduct.calories
            changeTextBasedOnRemainder(remainAmount: remainAmountCalorie, isWater: false)
            
            dayProgressComponent.caloriesProgressComponent.elementRemainLabel.text = String(remainAmountCalorie) + "kC"
        }
      
        
        
        
       recalculateProgressAfterDeleting(currentProduct: currentProduct)
        
        context.delete(consumedProducts[i])
        consumedProducts.remove(at: i)
        
        saveConsumedProduct()
    }
}
