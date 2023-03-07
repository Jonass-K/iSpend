//
//  String.swift
//  iSpend
//
//  Created by Jonas Kaiser on 07.03.23.
//

import Foundation

extension String {
    func split() -> (prefix: String, suffix: String) {
        let number = self.filter { $0.isNumber }
        
        let prefix = {
            let prefix = String(number.dropLast(2))
            if prefix.count == 0 {
                return "0"
            }
            return prefix
        }()
        let suffix: String = {
            let suffix = String(number.suffix(2))
            if suffix.count == 1 {
                return "0" + suffix
            }
            return suffix.padding(toLength: 2, withPad: "0", startingAt: 0)
        }()
        return (prefix, suffix)
    }
}
