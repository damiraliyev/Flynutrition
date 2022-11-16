//
//  Model.swift
//  Flynutrition
//
//  Created by Damir Aliyev on 16.11.2022.
//

import Foundation
import UIKit

enum Measure: String {
    case g
    case ml
}

struct Product {
    let name: String
    let amount: Int
    let calories: Int
    let proteins: Float
    let fats: Float
    let carbs: Float
    let measure: Measure
}
