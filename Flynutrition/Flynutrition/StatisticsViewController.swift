//
//  StatisticsViewController.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 19.12.2022.
//

import Foundation
import UIKit
import CoreData

class StatisticsViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView = UITableView()
    
    var dailyStatictics: [DailyStatistics] = []
    
    let stackView = makeStackView(axis: .vertical)
    let familiarizationLabel = UILabel()
    let statisticsImageView = UIImageView(image: UIImage(systemName: "doc.plaintext"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        view.backgroundColor = .white
        
       
        
        
        loadStatistics()
        setup()
        showLabelOrNot()
        layout()
        allowOnly7Items()

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
        
        familiarizationLabel.translatesAutoresizingMaskIntoConstraints = false
        familiarizationLabel.alpha = 0.5
        familiarizationLabel.text = "Your weekly statistics will be displayed here. This is your first day of using our app, so it's empty for now."
        familiarizationLabel.font = UIFont.systemFont(ofSize: 22)
        familiarizationLabel.numberOfLines = 0
        familiarizationLabel.textAlignment = .center
        
        statisticsImageView.translatesAutoresizingMaskIntoConstraints = false
        statisticsImageView.alpha = 0.3
        statisticsImageView.tintColor = .black


    
    }
    
    private func layout() {
        view.addSubview(tableView)
        view.addSubview(familiarizationLabel)
        view.addSubview(statisticsImageView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            familiarizationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            familiarizationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            familiarizationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -64)
        ])
        
        NSLayoutConstraint.activate([
            statisticsImageView.topAnchor.constraint(equalTo: familiarizationLabel.bottomAnchor, constant: 8),
            statisticsImageView.centerXAnchor.constraint(equalTo: familiarizationLabel.centerXAnchor),
            statisticsImageView.widthAnchor.constraint(equalToConstant: 100),
            statisticsImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        
    }
    
    
    func showLabelOrNot() {
        if dailyStatictics.count == 0 {
            familiarizationLabel.isHidden = false
            statisticsImageView.isHidden = false
            
        } else {
            
            familiarizationLabel.isHidden = true
            statisticsImageView.isHidden = true
            
        }
    }
    
}

extension StatisticsViewController: StatisticsDelegate {
    func dateChanged(statistics: DailyStatistics) {

        
        dailyStatictics.insert(statistics, at: 0)
 
        saveStatistics()
    }
    
    func allowOnly7Items() {
        if dailyStatictics.count == 8{
            context.delete(dailyStatictics[7])
            dailyStatictics.remove(at: 7)
            saveStatistics()
        }
    }
    
    
}


extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(dailyStatictics[indexPath.row])
            dailyStatictics.remove(at: indexPath.row)
            
            saveStatistics()
        }
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

//CoreData functions

extension StatisticsViewController {
    func saveStatistics() {
        do {
            try context.save()
        } catch {
            print("Error occured while saving statistics: \(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadStatistics() {
        let request: NSFetchRequest<DailyStatistics> = DailyStatistics.fetchRequest()
        
        do {
            dailyStatictics = try context.fetch(request).reversed()
        } catch {
            
        }
        tableView.reloadData()
    }
}

