//
//  SpendingsListView.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import SwiftUI
import CodableCSV

struct SpendingsListView: View {
    @State private var spendings: [Spending] = []
    @State private var importing: Bool = false
    
    private var parser = Parser(strategy: ZettlStrategy())
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(Array(spendings.enumerated()), id: \.element) { row, spending in
                        NavigationLink {
                            AddEditSpendingView(spending: spending, row: row)
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
                .refreshable { getSpendings() }
                
                HStack {
                    Spacer()
                    Button("Import Spendings") {
                        importing = true
                    }
                    Spacer()
                    
                    NavigationLink("Add Spending") {
                        AddEditSpendingView()
                    }
                    Spacer()
                }
            }
            .toolbar {
                NavigationLink {
                    StatisticsView(spendings)
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                        .foregroundStyle(.primary)
                }

                ShareLink(item: FileManager.default.spendingsFile)
            }
            .navigationTitle("Spendings")
            .fileImporter(isPresented: $importing,
                          allowedContentTypes: [.commaSeparatedText],
                          allowsMultipleSelection: false,
                          onCompletion: importCSV)
        }
    }
    
    private func importCSV(_ result: Result<[URL], Error>) {
        guard let url = try? result.get().first else { return }
        if url.lastPathComponent.hasPrefix("Zettl") {
            parser.strategy = ZettlStrategy()
        } else {
            parser.strategy = DefaultStrategy()
        }
        
        guard let spendings = try? parser.parse(url) else { return }

        try? Spending.save(spendings)
        self.spendings.append(contentsOf: spendings)
    }
    
    private func delete(at offsets: IndexSet) {
        var spendingsTemp = spendings
        spendingsTemp.remove(atOffsets: offsets)
        
        try? Spending.overwrite(spendingsTemp)
        spendings = spendingsTemp
    }
    
    private func getSpendings() {
        getSharedSpendings()
            
        do { spendings = try Spending.getAll() }
        catch {}
    }
    
    private func getSharedSpendings() {
        if let data = UserDefaults(suiteName: "group.iSpend")?.data(forKey: "zettl") {
            parser.strategy = ZettlStrategy()
            
            if let spendings = try? parser.parse(data) {
                try? Spending.save(spendings)
                UserDefaults(suiteName: "group.iSpend")?.set(nil, forKey: "zettl")
                self.spendings.append(contentsOf: spendings)
            }
        }
    }
}

struct SpendingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingsListView()
    }
}
