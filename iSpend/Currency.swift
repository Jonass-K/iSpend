//
//  Currency.swift
//  iSpend
//
//  Created by Jonas Kaiser on 12.02.23.
//

import Foundation

typealias Currency = Float

let CurrencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = "EUR"
    return formatter
}()
