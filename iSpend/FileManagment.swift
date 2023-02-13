//
//  FileManagment.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import Foundation
import CodableCSV

func getDocumentsDirectory() -> URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

func getSpendingsFile() -> URL {
    getDocumentsDirectory().appendingPathComponent("spendings.csv")
}

func parseZettlInput(_ url: URL) throws -> [Spending] {
    print("parse")
    var readerConfiguration = CSVReader.Configuration()
    readerConfiguration.headerStrategy = .firstLine
    
    print("before decode")
    do {
        url.startAccessingSecurityScopedResource()
        let csv = try CSVReader.decode(input: url, configuration: readerConfiguration)
    
    print("after decode")
    
    return csv.rows.flatMap { row in
        print(row)
        
        let csvDate = row[1].split(separator: ".")
        let date = Date.by(day: Int(csvDate[0])!, month: Int(csvDate[1])!, year: Int(csvDate[2])!)
        let description = row[4]
        let category = Category.food
        let priority = Priority.essential
        let price = Float(row[6].dropFirst(2))!
        let quantity = Int(row[7])!
        
        var spending: [Spending] = []
        
        for _ in 0..<quantity {
            spending.append(Spending(date: date, description: description, category: category, priority: priority, price: price))
        }
        return spending
    }
    } catch let error {
        print(error)
    }
    return []
}

func spendingsFileExists() throws -> Bool {
    do {
        let _ = try CSVReader(input: getSpendingsFile())
        return true
    } catch let error {
        if (error._code == 4) {
            return false
        }
        throw error
    }
}
