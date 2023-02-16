//
//  StatisticsView.swift
//  iSpend
//
//  Created by Jonas Kaiser on 15.02.23.
//

import SwiftUI

enum StatisticsGroup: String, CaseIterable, Identifiable {
    case category
    case priority
    
    var id: Self { self }
}

enum StatisticsChart: String, CaseIterable, Identifiable {
    case bar
    
    var id: Self { self }
}

struct StatisticsView: View {
    var data: [Spending]
    
    init(_ data: [Spending]) {
        self.data = data
    }
    
    @State var group: StatisticsGroup = .category
    @State var chart: StatisticsChart = .bar
    
    var body: some View {
        VStack {
            Picker("Group", selection: $group) {
                ForEach(StatisticsGroup.allCases) {
                    Text($0.rawValue.capitalized).tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            switch group {
            case .category:
                CategoryBarChart(data)
                    .padding()
            case .priority:
                PriorityBarChart(data)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Statistics")
    }
}

struct StatisticsView_Previews: PreviewProvider {
    
    static let data: [Spending] = [
        .init(category: .selfEntertainment, priority: .essential, price: 0),
        .init(category: .selfEntertainment, priority: .haveToHave, price: 50),
        .init(category: .selfEntertainment, priority: .niceToHave, price: 50),
        .init(category: .selfEntertainment, priority: .shouldntHave, price: 10),
        .init(category: .selfEntertainment, priority: .unprioritised, price: 10),
        .init(category: .food, priority: .essential, price: 300)
    ]
    
    static var previews: some View {
        StatisticsView(data)
    }
}
