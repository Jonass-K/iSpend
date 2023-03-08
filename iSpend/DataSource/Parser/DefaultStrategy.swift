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
        return configuration
    }
    
    func parse(_ input: CodableCSV.CSVReader.FileView) throws -> [Spending] {
        return input.rows.flatMap {
            do { return try [Spending(from: $0)] }
            catch { return [] as [Spending] }
        }
    }
}
