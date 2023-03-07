//
//  View.swift
//  iSpend
//
//  Created by Jonas Kaiser on 14.02.23.
//

import SwiftUI

extension View {
    func navigateBack(_ presentationMode: Binding<PresentationMode>) {
        presentationMode.wrappedValue.dismiss()
    }
    
    var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        return formatter
    }
    
    func toolbar_iOS<Content: ToolbarContent, Style: ShapeStyle>(style: Style, for bar: ToolbarPlacement, content: () -> Content) -> some View {
        self.toolbar(content: content).toolbarBackground(style, for: bar)
    }
}
