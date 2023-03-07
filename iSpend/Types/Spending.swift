//
//  Spending.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import Foundation
import CodableCSV
import Inject

struct Spending: Identifiable, Hashable {
    var id = UUID()
    var date: Date = Date()
    var description: String = ""
    var category: Category = .uncategorised
    var priority: Priority = .unprioritised
    var price: Currency = 0
    
    init(date: Date = Date(), description: String = "", category: Category = .uncategorised, priority: Priority = .unprioritised, price: Currency = 0) {
        self.date = date
        self.description = description
        self.category = category
        self.priority = priority
        self.price = price
    }
    
    func save(_ row: Int? = nil) throws {
        @Inject var Spendings: Spendings
        if let row { try Spendings.overwrite(row, with: self) }
        else { try Spendings.append(self) }
    }
}

extension Spending: CSVCodable {
    init(from row: [String]) throws {
        let date = row[0].split(separator: ".")
        let day = try Int(date[0]) ?! UnwrappedNilError.unwrapped("day of \(row)")
        let month = try Int(date[1]) ?! UnwrappedNilError.unwrapped("month of \(row)")
        let year = try Int(date[2]) ?! UnwrappedNilError.unwrapped("year of \(row)")
        
        self.date = Date.by(day: day, month: month, year: year)
        self.description = row[1]
        self.category = try Category(rawValue: row[2]) ?! UnwrappedNilError.unwrapped("category of \(row)")
        self.priority = try Priority(rawValue: row[3]) ?! UnwrappedNilError.unwrapped("priority of \(row)")
        self.price = try Float(row[4]) ?! UnwrappedNilError.unwrapped("price of \(row)")
    }
    
    func encode() -> [String] {
        [
            "\(date.get(.day))" + "." + "\(date.get(.month))" + "." + "\(date.get(.year))",
            description,
            category.rawValue,
            priority.rawValue,
            "\(price)"
        ]
    }
}
