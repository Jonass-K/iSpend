//
//  SpendingsInCategory.swift
//  iSpend
//
//  Created by Jonas Kaiser on 15.02.23.
//

import Foundation
import Charts

struct SpendingsPerCategory: Identifiable {
    var category: Category
    var id: Category { category.id }
    
    var spendings: [Spending]
}

struct SpendingsPerPriority: Identifiable {
    var priority: Priority
    var id: Priority { priority.id }
    
    var spendings: [Spending]
}

struct SpendingsPerMonth: Identifiable {
    var month: Date
    var id: Int { month.get(.month) }
    
    var spendings: [Spending]
}

struct SpendingsPerYear: Identifiable {
    var year: Date
    var id: Int { year.get(.year) }
    
    var spendings: [Spending]
}
