//
//  iSpendApp.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import SwiftUI
import CodableCSV

@main
struct iSpendApp: App {
    var body: some Scene {
        WindowGroup {
            SpendingsList()
        }
    }
    
    init() {
        do {
            print(getSpendingsFile())
            if (try !spendingsFileExists()) {
                var configuration = CSVWriter.Configuration()
                configuration.headers = ["Date", "Description", "Category", "Priority", "Price"]
                
                let writer = try CSVWriter(fileURL: getSpendingsFile(), append: false, configuration: configuration)
                try writer.endEncoding()
            }
        } catch let error {
            print(error)
            fatalError()
        }
    }
}
