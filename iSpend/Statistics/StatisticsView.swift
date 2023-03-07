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

func sortPerCategory(_ data: [Spending], spendingsPerCategory: [Spending]) -> [Spending] {
    var sortedData: [Spending] = []
    spendingsPerCategory.forEach { spending in
        let filteredData = data.filter { $0.category == spending.category }
        sortedData.append(contentsOf: filteredData)
    }
    return sortedData
}

func sortPerPriority(_ data: [Spending], spendingsPerPriority: [Spending]) -> [Spending] {
    var sortedData: [Spending] = []
    spendingsPerPriority.forEach { spending in
        let filteredData = data.filter { $0.priority == spending.priority }
        sortedData.append(contentsOf: filteredData)
    }
    return sortedData
}

struct StatisticsView: View {
    var spendingsPerCategory: [Spending]
    var spendingsPerPriority: [Spending]
    
    init(_ data: [Spending]) {
        let combinedData = Category.allCases.flatMap { category in
            Priority.allCases.map { priority in
                let price = data.filter { spending in
                    spending.category == category && spending.priority == priority
                }.reduce(0) { partialResult, spending in
                    partialResult + spending.price
                }
                return Spending(category: category, priority: priority, price: price)
            }
        }.sorted { $0.category.rawValue <= $1.category.rawValue }
        
        let spendingsPerCategory = Category.allCases.map { category in
            let price = combinedData.filter { spending in
                spending.category == category
            }.reduce(0) { partialResult, spending in
                partialResult + spending.price
            }
            return Spending(category: category, price: price)
        }.sorted { $0.price >= $1.price }

        let spendingsPerPriority = Priority.allCases.map { priority in
            let price = combinedData.filter { spending in
                spending.priority == priority
            }.reduce(0) { partialResult, spending in
                partialResult + spending.price
            }
            return Spending(priority: priority, price: price)
        }.sorted { $0.price >= $1.price }
        
        self.spendingsPerCategory = sortPerCategory(combinedData, spendingsPerCategory: spendingsPerCategory)
        self.spendingsPerPriority = sortPerPriority(combinedData, spendingsPerPriority: spendingsPerPriority)
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
                CategoryBarChart(spendingsPerCategory)
            case .priority:
                PriorityBarChart(spendingsPerPriority)
            }
            Spacer()
        }
        .padding(.horizontal)
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
