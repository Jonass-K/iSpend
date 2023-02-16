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
    
    func parse(_ url: URL, headerStrategy: Strategy.Header = .none) throws -> [Spending] {
        let _ = url.startAccessingSecurityScopedResource()
        
        do {
            let input = try CSVReader.decode(input: url, configuration: strategy.configuration)
            
            return try strategy.parse(input)
        }
        catch let error { print(error) }
        return []
    }
    
    func parse(_ data: Data) throws -> [Spending] {
        var readerConfiguration = CSVReader.Configuration()
        readerConfiguration.headerStrategy = .firstLine
        
        let input = try CSVReader.decode(input: data, configuration: readerConfiguration)
    
        return try strategy.parse(input)
    }
}

protocol ParseStrategy {
    var configuration: CSVReader.Configuration { get }
    
    func parse(_ input: CSVReader.FileView) throws -> [Spending]
}
