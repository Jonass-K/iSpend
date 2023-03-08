//
//  OldStrategy.swift
//  iSpend
//
//  Created by Jonas Kaiser on 08.03.23.
//

import Foundation
import CodableCSV

struct OldStrategy: ParseStrategy {
    var configuration: CSVReader.Configuration {
        var configuration = CSVReader.Configuration()
        configuration.headerStrategy = .firstLine
        configuration.delimiters = (field: ";", row: "\r\n")
        return configuration
    }
    
    func parse(_ input: CodableCSV.CSVReader.FileView) throws -> [Spending] {
        return input.rows.flatMap { row in
            do {
                let splittedDate = row[0].split(separator: ".")
                let day = try Int(splittedDate[0]) ?! UnwrappedNilError.unwrapped("day of \(row)")
                let month = try Int(splittedDate[1]) ?! UnwrappedNilError.unwrapped("month of \(row)")
                let year = try Int(splittedDate[2]) ?! UnwrappedNilError.unwrapped("year of \(row)")
                
                let date = Date.by(day: day, month: month, year: year)
                let description = row[1]
                let category = try Category(rawValue: row[2]) ?! UnwrappedNilError.unwrapped("category of \(row)")
                let priority = try Priority(rawValue: row[3]) ?! UnwrappedNilError.unwrapped("priority of \(row)")
                
                let priceString: String = String(row[4].dropLast(2)).replacingOccurrences(of: ",", with: ".")
                let price = try Float(priceString) ?! UnwrappedNilError.unwrapped("price of \(row)")
                
                return [Spending(date: date, description: description, category: category, priority: priority, price: price)]
            } catch {
                return [] as [Spending]
            }
        }
    }
}
