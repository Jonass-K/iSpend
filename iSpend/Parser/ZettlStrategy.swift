//
//  ParseStrategy.swift
//  iSpend
//
//  Created by Jonas Kaiser on 14.02.23.
//

import Foundation
import CodableCSV

struct ZettlStrategy: ParseStrategy {
    var configuration: CSVReader.Configuration {
        var configuration = CSVReader.Configuration()
        configuration.headerStrategy = .firstLine
        return configuration
    }
    
    func parse(_ input: CSVReader.FileView) throws -> [Spending] {
        input.rows.flatMap { row in
            let description = row[4]
        
            if (description == "REWE") { return [] as [Spending] }
        
            let dateSplitted = row[1].split(separator: ".")
            let date = Date.by(day: Int(dateSplitted[0])!, month: Int(dateSplitted[1])!, year: Int(dateSplitted[2])!)
            
            let category = Category.food
            let priority = Priority.essential
            let price = Float(row[6].dropFirst(2))!
            let quantity = Int(row[7])!
        
            let spending = Spending(date: date, description: description, category: category, priority: priority, price: price)
            return [Spending](repeating: spending, count: quantity)
        }
    }
}
