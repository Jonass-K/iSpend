//
//  Spendings.swift
//  iSpend
//
//  Created by Jonas Kaiser on 19.02.23.
//

import Foundation
import CodableCSV

class Spendings {
    var reader: CSVReader.FileView {
        var configuration = CSVReader.Configuration()
        configuration.headerStrategy = .firstLine
        
        return try! CSVReader.decode(input: FileManager.default.spendingsFile, configuration: configuration)
    }
    
    var appendingWriter: CSVWriter { try! CSVWriter(fileURL: FileManager.default.spendingsFile, append: true) }
    
    var overwritingWriter: CSVWriter {
        var configuration = CSVWriter.Configuration()
        configuration.headers = ["Date", "Description", "Category", "Priority", "Price"]
        
        return try! CSVWriter(fileURL: FileManager.default.spendingsFile, append: false, configuration: configuration)
    }
    
    func createFile() throws {
        let overwritingWriter = self.overwritingWriter
        try overwritingWriter.endEncoding()
    }
    
    func collect() throws -> [Spending]  {
        let spendings = reader.rows.flatMap {
            do { return try [Spending(from: $0)] }
            catch UnwrappedNilError.unwrapped(let field){
                print("Found nil while unwrapping: \(field).")
                return [] as [Spending]
            } catch {
                return [] as [Spending]
            }
        }

        return spendings
    }
    
    func sort(_ spendings: [Spending]) -> [Spending] {
        spendings.sorted { $0.date < $1.date }
    }
    
    func append(_ spending: Spending) throws {
        try append([spending])
    }
    
    func append(_ spendings: [Spending]) throws {
        let appendingWriter = self.appendingWriter
        
        try appendingWriter.write(spendings)
        try appendingWriter.endEncoding()
    }
    
    func overwrite(_ row: Int, with spending: Spending) throws {
        var spendings = try collect()
        spendings[row] = spending
        
        try overwrite(with: spendings)
    }
    
    func overwrite(with spendings: [Spending]) throws {
        let sortedSpendings = sort(spendings)
        
        let overwritingWriter = self.overwritingWriter
        
        try overwritingWriter.write(sortedSpendings)
        try overwritingWriter.endEncoding()
    }
    
    func delete() throws {
        try overwrite(with: [])
    }
}
