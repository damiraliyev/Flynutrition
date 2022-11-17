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
    
    let consumedProducts = [Product(name: "Rice", amount: 120, calories: 423, proteins: 10, fats: 15, carbs: 50, measure: .g),
                            Product(name: "Chocolate", amount: 100, calories: 500, proteins: 5, fats: 25, carbs: 62, measure: .g),
                            Product(name: "Cheese", amount: 50, calories: 120, proteins: 15, fats: 15, carbs: 45, measure: .g),
                            Product(name: "Milk", amount: 120, calories: 142, proteins: 8, fats: 10, carbs: 20, measure: .ml),
                            Product(name: "Potato", amount: 150, calories: 400, proteins: 12, fats: 23, carbs: 65, measure: .g)
    
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6
        title = "Today"
        setup()
        layout()
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
        
        
//        NSLayoutConstraint.activate([
//            todayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
//            todayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
        
        
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
        
        dayProgressComponent.caloriesProgressComponent.nutritionProgressView.progress = 0.9
        
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
}

extension DayStatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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


