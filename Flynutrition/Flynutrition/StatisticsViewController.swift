//
//  StatisticsViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 19.12.2022.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController {
    
    let tableView = UITableView()
    
    var dailyStatictics: [DailyStatistic] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        view.backgroundColor = .white
        setup()
        layout()
        
        
//        registerForNotifications()
        print(dailyStatictics.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func setup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(StatisticCell.self, forCellReuseIdentifier: StatisticCell.reuseID)
        tableView.rowHeight = 125
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
   
    
    @objc func addStatistics(_ notification: Notification) {
        print("HERE")
        let statistics = notification.userInfo?["dailyStatistics"] as! DailyStatistic
        
        dailyStatictics.append(statistics)
        tableView.reloadData()
    }
}

extension StatisticsViewController: StatisticsDelegate {
    func dateChanged(statistics: DailyStatistic) {
        let statistics = statistics
        dailyStatictics.append(statistics)
        tableView.reloadData()
    }
    
    
}


extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyStatictics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StatisticCell.reuseID, for: indexPath) as! StatisticCell
        cell.configureStatisticsCell(statistics: dailyStatictics[indexPath.row])
        return cell
    }
    
    
}
