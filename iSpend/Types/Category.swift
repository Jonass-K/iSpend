//
//  Category.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import Foundation
import Charts

enum Category: String, CaseIterable, Identifiable, Codable, Plottable {
    var id: Self { self }
    
    case housing = "Housing"
    case food = "Food and other things for living"
    case mensa = "Mensa"
    case eatingOut = "Eating Out"
    case clothing = "Clothing"
    case transportation = "Transportation"
    case mobile = "Phone/Internet"
    case health = "Health"
    case groupEntertainment = "Group-Entertainment"
    case selfEntertainment = "Self-Entertainment"
    case selfDevelopment = "Self-Development"
    case shopping = "Shopping"
    case fees = "Fees"
    case maintenance = "Maintenance"
    case uncategorised = ""
}
