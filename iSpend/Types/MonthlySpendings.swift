//
//  MonthlySpendings.swift
//  iSpend
//
//  Created by Jonas Kaiser on 06.03.23.
//

import Foundation

extension SpendingsListView {
    class MonthlySpendings: Identifiable {
        var id: String { MonthlySpendings.generateId(of: month, and: year) }
        var month: Int
        var year: Int
        var spendings: [SpendingListElement] = []
        
        init(_ spendings: SpendingListElement..., by month: Int, and year: Int)  {
            self.spendings.append(contentsOf: spendings)
            self.month = month
            self.year = year
        }
        
        func append(_ spendings: SpendingListElement...) {
            self.spendings.append(contentsOf: spendings)
        }
        
        static func generateId(of month: Int, and year: Int) -> String {
            "\(month);\(year)"
        }
    }
}
