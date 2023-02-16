//
//  PriorityBarChart.swift
//  iSpend
//
//  Created by Jonas Kaiser on 15.02.23.
//

import SwiftUI
import Charts

struct PriorityBarChart: View {
    var data: [Spending]
    
    var categoryColors: KeyValuePairs<Category, Color> = [
        .housing:.blue, .food: .green, .mensa: .mint, .eatingOut: .yellow, .clothing: .orange, .transportation: .brown, .mobile: .teal, .health:.cyan, .groupEntertainment:.purple, .selfEntertainment: .pink, .selfDevelopment: .indigo, .shopping:.orange, .fees: .red, .maintenance:.black, .uncategorised: .gray
    ]
    
    init(_ data: [Spending]) {
        self.data = data
    }
    
    var body: some View {
        GroupBox("Total Spendings per Priority") {
            Chart(data) {
                BarMark (
                    x: .value("Total Price", $0.price),
                    y: .value("Priority", $0.priority)
                )
                .foregroundStyle(by: .value("Category", $0.category))
            }
            .chartForegroundStyleScale(categoryColors)
        }
    }
}

struct PriorityBarChart_Previews: PreviewProvider {
    static let data: [Spending] = [
        .init(category: .selfEntertainment, priority: .essential, price: 0),
        .init(category: .selfEntertainment, priority: .haveToHave, price: 50),
        .init(category: .selfEntertainment, priority: .niceToHave, price: 50),
        .init(category: .selfEntertainment, priority: .shouldntHave, price: 10),
        .init(category: .selfEntertainment, priority: .unprioritised, price: 10),
        .init(category: .food, priority: .essential, price: 300)
    ]
    
    static var previews: some View {
        PriorityBarChart(data)
            .padding()
    }
}
