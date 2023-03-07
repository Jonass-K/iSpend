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
    
    @Binding var errorMessage: String
    @Binding var displayPopup: Bool
    
    init(spending: Spending = Spending(), row: Int? = nil, errorMessage: Binding<String>, displayPopup: Binding<Bool>) {
        self._spending = State(initialValue: spending)
        self.row = row
        self._errorMessage = errorMessage
        self._displayPopup = displayPopup
    }    
    
    var body: some View {
        List {
            TextField("Description", text: $spending.description)
            SpendingCategoryPicker($spending.category)
            SpendingPriorityPicker($spending.priority)
            CurrencyField($spending.price)
            DatePicker("Date", selection: $spending.date, displayedComponents: .date)
        }
        .navigationTitle(row == nil ? "Add Spending" : "Edit spending")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: save)
            }
        }
    }
    
    func save() {
        do {
            try spending.save(row)
            navigateBack(presentationMode)
        }
        catch {
            print(error)
            self.errorMessage = "Spending couldn't be saved"
            withAnimation(.easeOut(duration: 0.5)) {
                displayPopup = true
            }
        }
    }
}

fileprivate struct ContentView_PreviewsHelper: View {
    @State private var errorMessage: String = ""
    @State private var displayPopup: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                AddEditSpendingView(errorMessage: $errorMessage,
                                    displayPopup: $displayPopup)
            }
            Popup($errorMessage, display: $displayPopup)
        }
        NavigationStack {
            AddEditSpendingView(
                spending: .init(
                    date: Date(),
                    description: "Spending",
                    category: .eatingOut,
                    priority: .niceToHave,
                    price: 20),
                row: 1,
                errorMessage: $errorMessage,
                displayPopup: $displayPopup
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_PreviewsHelper()
    }
}
