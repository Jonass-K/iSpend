//
//  Spending.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import Foundation
import CodableCSV

infix operator ?!: NilCoalescingPrecedence

/// Throws the right hand side error if the left hand side optional is `nil`.
func ?!<T>(value: T?, error: @autoclosure () -> Error) throws -> T {
    guard let value = value else {
        throw error()
    }
    return value
}

struct UnwrappedNilError: Error {}

struct Spending: Codable, Identifiable, Hashable {
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
    
    init(from csv: [String]) throws {
        let csvDate = csv[0].split(separator: ".")
        print(csvDate[0])
        print(csvDate[1])
        print(csvDate[2])
        date = try Date.by(day: Int(csvDate[0]) ?! UnwrappedNilError(),
                       month: Int(csvDate[1]) ?! UnwrappedNilError(),
                       year: Int(csvDate[2]) ?! UnwrappedNilError())
        description = csv[1]
        print(csv[2])
        category = try Category(rawValue: csv[2]) ?! UnwrappedNilError()
        print(csv[3])
        priority = try Priority(rawValue: csv[3]) ?! UnwrappedNilError()
        print(csv[4])
        price = try Float(csv[4]) ?! UnwrappedNilError()
    }
    
    func save(row: Int? = nil) throws {
        if let row {
            try edit(row)
            return
        }
        
        let writer = try CSVWriter(fileURL: FileManager.default.spendingsFile,
                                   append: true)
        
        try writer.write(row: csvEncoded())
        try writer.endEncoding()
    }
    
    private func edit(_ row: Int) throws {
        var spendings = try Spending.getAll()
        spendings[row] = self
        
        try Spending.overwrite(spendings)
    }
    
    private func csvEncoded() -> [String] {
        [
            "\(date.get(.day))" + "." + "\(date.get(.month))" + "." + "\(date.get(.year))",
            description,
            category.rawValue,
            priority.rawValue,
            "\(price)"
        ]
    }
    
    static func overwrite(_ spendings: [Spending]) throws {
        var configuration = CSVWriter.Configuration()
        configuration.headers = ["Date", "Description", "Category", "Priority", "Price"]
        
        let writer = try CSVWriter(fileURL: FileManager.default.spendingsFile,
                                   append: false, configuration: configuration)
        
        try spendings.forEach { try writer.write(row: $0.csvEncoded()) }
        try writer.endEncoding()
    }
    
    static func save(_ spendings: [Spending]) throws {
        try spendings.forEach { try $0.save() }
    }
    
    static func getAll() throws -> [Spending] {
        var readerConfiguration = CSVReader.Configuration()
        readerConfiguration.headerStrategy = .firstLine
        
        let csv = try CSVReader.decode(input: FileManager.default.spendingsFile,
                                       configuration: readerConfiguration)
    
        return try csv.rows.map { try Spending(from: $0) }
    }
}
