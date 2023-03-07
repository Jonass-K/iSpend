//
//  FileManagment.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import Foundation
import CodableCSV
import Inject
    
extension FileManager {
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    var spendingsFile: URL {
        documentsDirectory.appendingPathComponent("spendings.csv")
    }
    
    var spendingsFileExists: Bool {
        FileManager.default.fileExists(atPath: spendingsFile.path)
    }
}
