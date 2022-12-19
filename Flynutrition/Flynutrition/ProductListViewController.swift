//
//  AddProductsViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit
import CoreData

class ProductListViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var searchController = UISearchController()
    
    let searchBar = UISearchBar()
    
    let tableView = UITableView()
    
    var products: [Product] = []
    
    let defaults = UserDefaults.standard
        
    var isLoaded = false

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Add products"
        
        
        loadProducts()
        
        setup()
        layout()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
        let addedNewProduct = notification.userInfo?["product"] as! Product
       
        products.append(addedNewProduct)
        saveProduct()
        print(products.count)
    }
    
    
    func addInitialProducts() {
        let productNames = ["Water", "Potato", "Rice", "Banana"]
        let productCalories = [0, 77, 130, 89]
        let productProteins = [0, 2, 2.7, 1.1]
        let productFats = [0, 0.1, 0.3, 0.3]
        let productCarbs = [0, 17, 28, 23]
        let productMeasures = ["ml", "g", "g", "g"]
        
        for i in 0...productNames.count-1 {
            let initialProduct = Product(context: context)
            initialProduct.name = productNames[i]
            initialProduct.amount = 100
            initialProduct.calories = Int32(productCalories[i])
            initialProduct.proteins = Float(productProteins[i])
            initialProduct.fats = Float(productFats[i])
            initialProduct.carbs = Float(productCarbs[i])
            initialProduct.measure = productMeasures[i]
            
            products.append(initialProduct)
            saveProduct()
            
        }
        LocalState.hasLoaded = true
        
    }
    
    

}

extension ProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productInfoVC = ProductInfoViewController()
        
        productInfoVC.configureProductInfo(product: products[indexPath.row])
        
        navigationController?.pushViewController(productInfoVC, animated: false)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddProductCell.reuseID, for: indexPath) as! AddProductCell
        cell.configureProductCell(product: products[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if products[indexPath.row].name?.lowercased() == "water" {
                return
            }
            context.delete(products[indexPath.row])
            products.remove(at: indexPath.row)
            
            saveProduct()
            tableView.reloadData()
        }
    }
    
    
}

extension ProductListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}

extension ProductListViewController: UISearchControllerDelegate {
    
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

extension ProductListViewController: UISearchBarDelegate {
    
}

//MARK: - CoreData functions

extension ProductListViewController {
    func saveProduct() {
        do {
            try context.save()
        } catch {
            print("Error occured while saving new product: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()

        do {
            products = try context.fetch(request)
            
            if !LocalState.hasLoaded {
                addInitialProducts()
            }
        } catch {
            print("Error occured while saving new product: \(error)")
        }
        tableView.reloadData()
    }
}
