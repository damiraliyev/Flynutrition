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
        
        searchController.searchBar.delegate = self
        
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
        let productNames = ["Water", "Potato", "Carrot", "Rice", "Banana", "Apple", "Orange", "Spaghetti(Sultan)", "Macaroni(Sultan)", "Buckwheat", "Oats","Sour cream 10%", "Sour cream 15%", "Sour cream 20%", "Milk(Lactel)", "Butter 82%", "White bread", "Rye bread", "Snickers (small)"]
        let productCalories = [0, 77, 41, 130, 89, 52, 47, 344, 344, 343, 379, 118, 162, 206, 43, 743, 265, 259, 250]
        let amounts = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 50]
        let productProteins = [0, 2, 0.9, 2.7, 1.1, 0.3, 0.9, 10.4, 10.4, 13.3, 13.2, 2.85, 2.8, 2.7, 2.8, 0.7, 9, 9, 4]
        let productFats = [0, 0.1, 0.3, 0.2, 0.3, 0.2, 0.1, 1.1, 1.1, 3.4, 6.52, 10, 15, 20, 1.5, 82, 3.2, 3.3, 12.8]
        let productCarbs = [0, 17, 10, 28, 23, 14, 12, 71.5, 71.5, 71.5, 67.7, 4.2, 4, 3.8, 4.6, 0.5, 49, 48, 28]
        let productMeasures = ["ml", "g", "g","g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "g", "ml", "g", "g", "g", "g"]
        
        for i in 0...productNames.count-1 {
            let initialProduct = Product(context: context)
            initialProduct.name = productNames[i]
            initialProduct.amount = Int32(amounts[i])
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
    
    
    
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text! == "" {
            loadProducts()
            
        } else {
            let request: NSFetchRequest<Product> = Product.fetchRequest()
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            loadProducts(with: request)
            
        }
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadProducts()
        tableView.reloadData()
    }
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
    
    func loadProducts(with request: NSFetchRequest<Product> = Product.fetchRequest()) {

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
