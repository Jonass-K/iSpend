//
//  CSVWriter.swift
//  iSpend
//
//  Created by Jonas Kaiser on 21.02.23.
//

import Foundation
import CodableCSV

extension CSVWriter {
    func write(_ rows: [any CSVEncodable]) throws {
        rows.forEach {
            try? write($0)
        }
    }
    
    func write(_ row: any CSVEncodable) throws {
        try write(row: row.encode())
    }
}
