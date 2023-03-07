//
//  SpendingListElement.swift
//  iSpend
//
//  Created by Jonas Kaiser on 06.03.23.
//

import Foundation

struct SpendingListElement: Identifiable {
    var id: UUID {
        spending.id
    }
    var spending: Spending
    var row: Int
    
    init(_ spending: Spending, at row: Int) {
        self.spending = spending
        self.row = row
    }
}
