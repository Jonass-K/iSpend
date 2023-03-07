//
//  CurrencyField.swift
//  iSpend
//
//  Created by Jonas Kaiser on 07.03.23.
//

import SwiftUI

struct CurrencyField: View {
    @Binding var number: Float
    
    init(_ number: Binding<Float>) {
        self._number = number
        var number_ = ""
        if number.wrappedValue != 0 {
            number_ = String(format: "%.2f", number.wrappedValue)
            number_ = number_.filter { $0.isNumber }
        }
        let (prefix, suffix) = number_.split()
        numberFormatted =  prefix + "." + suffix
        self.number_ = number_
    }
    
    @State private var number_: String
    @State private var numberFormatted: String
    @State private var value: String = " "
    
    var body: some View {
        ZStack {
            HStack {
                Text("Price")
                Spacer()
                Text(numberFormatted)
                Text("€")
            }
            
            HStack {
                TextField("", text: $value)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: value) { newNumber in
                        if newNumber == "" {
                            _ = number_.popLast()
                        } else if number_.count < 15 {
                            number_ += newNumber.filter { $0.isNumber }
                        }
                        value = " "
                    }.onChange(of: number_) { newNumber in
                        let (prefix, suffix) = newNumber.split()
                        self.number = Float(prefix) ?? 0
                        self.number += ((Float(suffix) ?? 0) / 100)
                        print("suffix: \((Float(suffix) ?? 0) / 100)")
                        print("prefix: \(prefix)")
                        print("number: \(number)")
                        numberFormatted =  prefix + "." + suffix
                    }
                Text("€")
            }
        }
    }
}

fileprivate struct Helper: View {
    @State var text = ""
    @State var number: Float = 84.1
    
    var body: some View {
        List {
            TextField("Description", text: $text)
            CurrencyField($number)
        }
        .padding()
    }
}

struct CurrencyField_Previews: PreviewProvider {
    static var previews: some View {
        Helper()
    }
}
