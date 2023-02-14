//
//  AddEditSpendingView.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import SwiftUI
import CodableCSV

struct AddEditSpendingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var spending = Spending()
    var row: Int? = nil
    
    var body: some View {
        VStack {
            List {
                TextField("Description", text: $spending.description)
                
                Picker("Category", selection: $spending.category) {
                    ForEach(Category.allCases) { category in
                        Text(category.rawValue).tag(category as Category?)
                    }
                    Text("").tag(nil as Category?)
                }
                Picker("Priority", selection: $spending.priority) {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.rawValue).tag(priority as Priority?)
                    }
                    Text("").tag(nil as Priority?)
                }
                TextField("Price", value: $spending.price, formatter: currencyFormatter)
                
                DatePicker("Date", selection: $spending.date)
            }
            
            HStack {
                Spacer()
                Button("Cancel", action: cancel)
                    .foregroundColor(.red)
                Spacer()
                Button("Save", action: save)
                Spacer()
            }
        }
        .navigationTitle(row == nil ? "Add Spending" : "Edit spending")
    }
    
    func cancel() {
        navigateBack(presentationMode)
    }
    
    func save() {
        try? spending.save(row: row)
        navigateBack(presentationMode)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditSpendingView()
    }
}
