//
//  CSVCodable.swift
//  iSpend
//
//  Created by Jonas Kaiser on 21.02.23.
//

import Foundation

protocol CSVEncodable {
    func encode() -> [String]
}

protocol CSVDecodable {
    init(from row: [String]) throws
}

typealias CSVCodable = CSVEncodable & CSVDecodable
