//
//  Priority.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import Foundation
import Charts

enum Priority: String, CaseIterable, Identifiable, Codable, Plottable {
    var id: Self { self }
    
    case essential = "Essential"
    case haveToHave = "Have to Have"
    case niceToHave = "Nice to Have"
    case shouldntHave = "Shouldn't Have"
    case unprioritised = "Unprioritised"
}
