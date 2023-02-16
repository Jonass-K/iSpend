//
//  CategoryBarChart.swift
//  iSpend
//
//  Created by Jonas Kaiser on 15.02.23.
//

import SwiftUI
import Charts

struct CategoryBarChart: View {
    var data: [Spending]
    
    var priorityColors: KeyValuePairs<Priority, Color> = [
        .essential: .green, .haveToHave: .blue, .niceToHave: .purple, .shouldntHave: .pink, .unprioritised: .gray
    ]
    
    init(_ data: [Spending]) {
        self.data = data
    }
    
    var body: some View {
        GroupBox("Total Spendings per Category") {
            Chart(data) {
                BarMark (
                    x: .value("Total Price", $0.price),
                    y: .value("Category", $0.category)
                )
                .foregroundStyle(by: .value("Priority", $0.priority))
            }
            .chartForegroundStyleScale(priorityColors)
        }
    }
}

struct CategoryBarChart_Previews: PreviewProvider {
    static let data: [Spending] = [
        .init(category: .selfEntertainment, priority: .essential, price: 0),
        .init(category: .selfEntertainment, priority: .haveToHave, price: 50),
        .init(category: .selfEntertainment, priority: .niceToHave, price: 50),
        .init(category: .selfEntertainment, priority: .shouldntHave, price: 10),
        .init(category: .selfEntertainment, priority: .unprioritised, price: 10),
        .init(category: .food, priority: .essential, price: 300)
    ]
    
    static var previews: some View {
        CategoryBarChart(data)
            .padding()
    }
}
