//
//  AddProductsViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 13.11.2022.
//

import Foundation
import UIKit

class AddProductsViewController: UIViewController {
    
    var searchController = UISearchController()
    
    let tableView = UITableView()
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Add products"

        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationController?.navigationItem.searchController = searchController
        


        setup()
        layout()
    }
    
    func setup() {
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        setupTableView()
    }
    
    func layout() {
        view.addSubview(searchController.searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchController.searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchController.searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchController.searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchController.searchBar.bottomAnchor, constant: 8),
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
    

}

extension AddProductsViewController: UITableViewDelegate {
    
}

extension AddProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddProductCell.reuseID, for: indexPath) as! AddProductCell
        
        return cell
    }
    
    
}

extension AddProductsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}

extension AddProductsViewController: UISearchControllerDelegate {
    
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

extension AddProductsViewController: UISearchBarDelegate {
    
}
