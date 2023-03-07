//
//  SpendingsListView.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import SwiftUI
import CodableCSV
import Inject

struct SpendingsListView: View {
    @Inject private var Spendings: Spendings
    
    @State private var spendings: [Spending] = []
    
    @State private var importing: Bool = false
    @State private var importError: Bool = false
    
#if os(iOS)
    @State private var editMode = EditMode.inactive
#endif
    
    private var parser = Parser(strategy: ZettlStrategy())
    private var total: Currency {
        spendings.reduce(0) { partialResult, spending in
            partialResult + spending.price
        }
    }
    
    private var spendingsByMonth: [MonthlySpendings] {
        var spendingsByMonth: [MonthlySpendings] = []
        spendings.enumerated().forEach { row, spending in
            let element = SpendingListElement(spending, at: row)
            
            let month = spending.date.get(.month)
            let year = spending.date.get(.year)
            
            if let monthlySpendings = spendingsByMonth.first(where: {
                $0.id == MonthlySpendings.generateId(of: month, and: year)
            }) {
                monthlySpendings.append(element)
            } else {
                spendingsByMonth.append(.init(element, by: month, and: year))
            }
        }
        return spendingsByMonth
    }
    
    @State var errorMessage: String = ""
    @State var displayPopup: Bool = false
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(spendingsByMonth) { monthlySpendings in
                        Section(header: SectionTitle(year: monthlySpendings.year, month: monthlySpendings.month)) {
                            ForEach(monthlySpendings.spendings) { element in
                                let spending = element.spending
                                let row = element.row
                                
                                NavigationLink {
                                    AddEditSpendingView(spending: spending, row: row, errorMessage: $errorMessage, displayPopup: $displayPopup)
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
                    }
                }
                .navigationTitle("Spendings")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink {
                            StatisticsView(spendings)
                        } label: {
                            Image(systemName: "chart.xyaxis.line")
                        }
                    }
                    
                    ToolbarItem(placement: .secondaryAction) {
                        Button {
                            self.spendings = Spendings.sort(spendings)
                        } label: {
                            HStack {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                                Text("Sort by date")
                            }
                        }
#if os(iOS)
                        .disabled(editMode.isEditing)
#endif
                    }
                    
                    ToolbarItem(placement: .secondaryAction) {
                        Button {
                            do {
                                try Spendings.delete()
                                self.spendings = []
                            }
                            catch {
                                print(error)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "delete.left")
                                Text("Delete all")
                            }
                        }
                    }
                    
                    ToolbarItem() {
                        ShareLink(item: FileManager.default.spendingsFile)
#if os(iOS)
                            .disabled(editMode.isEditing)
#endif
                    }
                }
#if os(iOS)
                .toolbar_iOS(style: .ultraThinMaterial, for: .bottomBar) {
                    ToolBarItems_iOS(importing: $importing, importError: $importError, total: total, isEditing: editMode.isEditing, errorMessage: $errorMessage, displayPopup: $displayPopup)
                }
                .environment(\.editMode, $editMode)
#endif
                .onAppear(perform: fetchSpendings)
                .refreshable { fetchSpendings() }
                .fileImporter(isPresented: $importing,
                              allowedContentTypes: [.commaSeparatedText],
                              allowsMultipleSelection: false,
                              onCompletion: importCSV)
                
            }
            Popup($errorMessage, display: $displayPopup)
        }
    }
    
    private func importCSV(_ result: Result<[URL], Error>) {
        Task {
            guard let url = try? result.get().first else { return }
            if url.lastPathComponent.hasPrefix("Zettl") {
                parser.strategy = ZettlStrategy()
            } else {
                parser.strategy = DefaultStrategy()
            }
            
            do {
                let spendings = try parser.parse(url)
                try append(spendings)
            } catch {
                withAnimation(.easeOut(duration: 0.5)) {
                    importError = true
                }
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        var spendings = self.spendings
        spendings.remove(atOffsets: offsets)
        
       try? overwrite(with: spendings)
    }
    
    // TODO: Display Error
    private func fetchSpendings() {
        appendSharedSpendings()
            
        do {
            let spendings = try Spendings.collect()
            print("Collected spendings: \(spendings)")
            self.spendings = spendings
        } catch let error {
            print(error)
        }
    }
    
    private func appendSharedSpendings() {
        if let data = UserDefaults(suiteName: "group.iSpend")?.data(forKey: "zettl") {
            print("share")
            parser.strategy = ZettlStrategy()
            
            if let spendings = try? parser.parse(data) {
                try? append(spendings)
            }
        }
        UserDefaults(suiteName: "group.iSpend")?.set(nil, forKey: "zettl")
    }
    
    private func append(_ spendings: [Spending]) throws {
        try Spendings.append(spendings)
        self.spendings.append(contentsOf: spendings)
    }
    
    private func overwrite(with spendings: [Spending]) throws {
        try? Spendings.overwrite(with: spendings)
        self.spendings = spendings
    }
}

fileprivate struct SectionTitle: View {
    var year: Int
    var month: Int
    
    var body: some View {
        Text(verbatim: "\(month < 10 ? "0" : "")\(month).\(year)")
    }
}

#if os(iOS)
struct ToolBarItems_iOS: ToolbarContent {
    @Binding var importing: Bool
    @Binding var importError: Bool
    var total: Currency
    
    var isEditing: Bool
    
    @Binding var errorMessage: String
    @Binding var displayPopup: Bool
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            EditButton()
        }
        
        ToolbarItem(placement: .bottomBar) {
            Button {
                importing = true
            } label: {
                Image(systemName: "square.and.arrow.down.on.square")
            }.disabled(isEditing)
        }
        
        
        ToolbarItem(placement: .status) {
            ZStack {
                Text(importError ? "" : "\(String(format: "%.2f", total))€ total")
                    .font(.caption2)
                    .transition(.opacity)
                    .id(importError ? "StatusError" : "StatusTotal")
                
                Text("File has wrong format")
                    .font(.caption2)
                    .offset(y: importError ? 0 : 200)
                    .transition(.slide)
                    .onChange(of: importError) { _ in
                        if importError {
                            Task {
                                try? await Task.sleep(for: .seconds(3.0))
                            
                                withAnimation(.easeOut(duration: 0.5)) {
                                    importError = false
                                }
                            }
                        }
                    }
            }
        }
        ToolbarItem(placement: .bottomBar) {
            NavigationLink {
                AddEditSpendingView(errorMessage: $errorMessage, displayPopup: $displayPopup)
            } label: {
                Image(systemName: "rectangle.stack.badge.plus")
            }
        }
    }
}
#endif

struct SpendingsListView_Previews: PreviewProvider {
    static var previews: some View {
        SpendingsListView()
    }
}
