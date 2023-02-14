//
//  Parser.swift
//  iSpend
//
//  Created by Jonas Kaiser on 14.02.23.
//

import Foundation
import CodableCSV

class Parser {
    var strategy: ParseStrategy
    
    init(strategy: ParseStrategy) {
        self.strategy = strategy
    }
    
    func parse(_ url: URL) throws -> [Spending] {
        var readerConfiguration = CSVReader.Configuration()
        readerConfiguration.headerStrategy = .firstLine
        
        let _ = url.startAccessingSecurityScopedResource()
        let input = try CSVReader.decode(input: url, configuration: readerConfiguration)
        
        return try strategy.parse(input)
    }
    
    func parse(_ data: Data) throws -> [Spending] {
        var readerConfiguration = CSVReader.Configuration()
        readerConfiguration.headerStrategy = .firstLine
        
        let input = try CSVReader.decode(input: data, configuration: readerConfiguration)
    
        return try strategy.parse(input)
    }
}

