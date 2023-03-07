//
//  iSpendApp.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import SwiftUI
import CodableCSV
import Inject

@main
struct iSpendApp: App {
    var body: some Scene {
        WindowGroup {
            SpendingsListView()
        }
    }
    
    init() {
        do {
            @Dependency var Spendings = Spendings()
            if FileManager.default.spendingsFileExists {
                return
            }
            try Spendings.createFile()
        } catch {
            fatalError()
        }
    }
}
