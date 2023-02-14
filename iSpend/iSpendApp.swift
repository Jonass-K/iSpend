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
            try FileManager.default.createSpendingsFile()
        } catch {
            fatalError()
        }
    }
}
