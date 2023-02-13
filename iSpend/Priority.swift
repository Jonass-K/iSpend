//
//  Priority.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import Foundation

enum Priority: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }
    
    case essential = "Essential"
    case haveToHave = "Have to have"
    case niceToHave = "Nice to have"
    case shouldntHave = "Shouldn't Have"
}
