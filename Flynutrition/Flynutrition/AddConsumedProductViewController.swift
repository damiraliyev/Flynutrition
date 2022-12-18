//
//  AddProductsViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit

class AddConsumedProductViewController: UIViewController {
    
    var searchController = UISearchController()
    
    let searchBar = UISearchBar()
    
    let tableView = UITableView()
    
    var products = [Product(name: "Rice", amount: 100, calories: 130, proteins: 2.7, fats: 0.3, carbs: 28, measure: .g),
                    Product(name: "Chocolate", amount: 100, calories: 500, proteins: 5, fats: 25, carbs: 62, measure: .g),
                    Product(name: "Cheese", amount: 50, calories: 120, proteins: 15, fats: 15, carbs: 45, measure: .g),
                    Product(name: "Milk", amount: 120, calories: 142, proteins: 8, fats: 10, carbs: 20, measure: .ml),
                    Product(name: "Water", amount: 120, calories: 0, proteins: 0, fats: 0, carbs: 0, measure: .ml),
                    Product(name: "Potato", amount: 150, calories: 400, proteins: 12, fats: 23, carbs: 65, measure: .g),
                    Product(name: "Rice", amount: 100, calories: 130, proteins: 2.7, fats: 0.3, carbs: 28, measure: .g),
                    Product(name: "Chocolate", amount: 100, calories: 500, proteins: 5, fats: 25, carbs: 62, measure: .g),
                    Product(name: "Cheese", amount: 50, calories: 120, proteins: 15, fats: 15, carbs: 45, measure: .g),
                    Product(name: "Milk", amount: 120, calories: 142, proteins: 8, fats: 10, carbs: 20, measure: .ml),
                    Product(name: "Potato", amount: 150, calories: 400, proteins: 12, fats: 23, carbs: 65, measure: .g)
    ]
        

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Add products"
        setup()
        layout()
    }
    
    func setup() {
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        setupTableView()
        
        let plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewProductToList))
        
        navigationItem.rightBarButtonItem = plusBarButtonItem
        
        registerForNotifications()
    }
    
    func layout() {

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddProductCell.self, forCellReuseIdentifier: AddProductCell.reuseID)
        tableView.layer.cornerRadius = 10
        tableView.rowHeight = 52
        
    }
    
    @objc func addNewProductToList() {
        let addNewProductVC = AddNewProductViewController()
        
        navigationController?.pushViewController(addNewProductVC, animated: false)
    }
    
    private func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(newProductAddedToList), name: newProductAdded, object: nil)
    }
    
    @objc func newProductAddedToList(notification: Notification) {
        let newProduct = notification.userInfo?["product"] as! Product
        print(newProduct)
        products.append(newProduct)
        tableView.reloadData()
    }
    

}

extension AddConsumedProductViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productInfoVC = ProductInfoViewController()
        
        productInfoVC.configureProductInfo(product: products[indexPath.row])
        
        navigationController?.pushViewController(productInfoVC, animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension AddConsumedProductViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddProductCell.reuseID, for: indexPath) as! AddProductCell
        cell.configureProductCell(product: products[indexPath.row])
        return cell
    }
    
    
}

extension AddConsumedProductViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}

extension AddConsumedProductViewController: UISearchControllerDelegate {
    
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

extension AddConsumedProductViewController: UISearchBarDelegate {
    
}
