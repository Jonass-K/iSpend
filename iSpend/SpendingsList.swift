//
//  SpendingsList.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import SwiftUI
import CodableCSV

struct SpendingsList: View {
    @State private var spendings: [Spending] = []
    @State private var importing: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(Array(spendings.enumerated()), id: \.element) { row, spending in
                        NavigationLink {
                            ContentView(spending: spending, row: row)
                        } label: {
                            HStack {
                                Text(spending.description)
                                Spacer()
                                Text(spending.price, format: .currency(code: "EUR"))
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
                .onAppear(perform: getSpendings)
                
                HStack {
                    Spacer()
                    Button {
                        importing = true
                    } label: {
                        Text("Import Spendings")
                    }
                    Spacer()
                    
                    NavigationLink {
                        ContentView()
                    } label: {
                        Text("Add Spending")
                    }
                    Spacer()
                }
            }
            .toolbar {
                ShareLink(item: getSpendingsFile())
            }
            .navigationTitle("Spendings")
            .fileImporter(isPresented: $importing, allowedContentTypes: [.commaSeparatedText], allowsMultipleSelection: false) { result in
                print("import")
                guard let url = try? result.get().first else { return }
                print("url: \(url)")
                if let spendings = try? parseZettlInput(url) {
                    print("input finished: \(spendings)")
                    try? Spending.save(spendings)
                    self.spendings.append(contentsOf: spendings)
                    print("save finished")
                }
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        spendings.remove(atOffsets: offsets)
        do {
            try Spending.overwrite(spendings)
        } catch let error {
            print(error)
        }
    }
    
    func getSpendings() {
        do {
            spendings = try Spending.getAll()
        } catch let error {
            print("error")
            print(error)
        }
    }
}

struct SpendingsList_Previews: PreviewProvider {
    static var previews: some View {
        SpendingsList()
    }
}
