//
//  SpendingCategoryPicker.swift
//  iSpend
//
//  Created by Jonas Kaiser on 28.02.23.
//

import SwiftUI

struct SpendingCategoryPicker: View {
    @Binding var category: Category
    
    init(_ category: Binding<Category>) {
        self._category = category
    }
    
    var body: some View {
        Picker("Category", selection: self.$category) {
            ForEach(Category.allCases) { category in
                Text(category.rawValue).tag(category)
            }
        }
    }
}

fileprivate struct SpendingCategoryPicker_PreviewsHelper: View {
    @State var category: Category = .uncategorised
    
    var body: some View {
        SpendingCategoryPicker($category)
    }
}

struct SpendingCategoryPicker_Previews: PreviewProvider {
    static var previews: some View {
        SpendingCategoryPicker_PreviewsHelper()
    }
}
