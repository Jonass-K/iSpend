//
//  DefaultStrategy.swift
//  iSpend
//
//  Created by Jonas Kaiser on 15.02.23.
//

import Foundation
import CodableCSV

struct DefaultStrategy: ParseStrategy {
    var configuration: CSVReader.Configuration {
        var configuration = CSVReader.Configuration()
        configuration.headerStrategy = .firstLine
        configuration.delimiters = (field: ";", row: "\r\n")
        return configuration
    }
    
    func parse(_ input: CodableCSV.CSVReader.FileView) throws -> [Spending] {
        print("import")
        return try input.rows.compactMap { row in
            print("row: \(row)")
            
            let csvDate = row[0].split(separator: ".")
            let date = try Date.by(day: Int(csvDate[0]) ?! UnwrappedNilError(),
                           month: Int(csvDate[1]) ?! UnwrappedNilError(),
                           year: Int(csvDate[2]) ?! UnwrappedNilError())
            let description = row[1]
            let category = try Category(rawValue: row[2]) ?! UnwrappedNilError()
            let priority = try Priority(rawValue: row[3]) ?! UnwrappedNilError()
            let priceString: String = String(row[4].dropLast(2)).replacingOccurrences(of: ",", with: ".")
            
            print(priceString)
            let price = Float(priceString) ?? 0
            print(price)
            return Spending(date: date, description: description, category: category, priority: priority, price: price)
        }
    }
}
