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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemGray6
        setup()
        layout()
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
        
        
    }
    
    func layout() {
        view.addSubview(todayLabel)
        view.addSubview(dayProgressComponent)
        view.addSubview(recentlyAddedLabel)
        view.addSubview(dayTableView)
        
        
        NSLayoutConstraint.activate([
            todayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            todayLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            dayProgressComponent.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 16),
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
            dayTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        dayTableView.rowHeight = 55
    }
}

extension DayStatisticsViewController: UITableViewDelegate {
    
}
extension DayStatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConsumedProductCell.reuseID, for: indexPath) as! ConsumedProductCell

        return cell
    }
}


