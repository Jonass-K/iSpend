//
//  SpendingPriorityPicker.swift
//  iSpend
//
//  Created by Jonas Kaiser on 28.02.23.
//

import SwiftUI

struct SpendingPriorityPicker: View {
    @Binding var priority: Priority
    
    init(_ priority: Binding<Priority>) {
        self._priority = priority
    }
    
    var body: some View {
        Picker("Priority", selection: self.$priority) {
            ForEach(Priority.allCases) { priority in
                Text(priority.rawValue).tag(priority)
            }
        }
    }
}

fileprivate struct SpendingPriorityPicker_PreviewsHelper: View {
    @State var priority: Priority = .unprioritised
    
    var body: some View {
        SpendingPriorityPicker($priority)
    }
}

struct SpendingPriorityPicker_Previews: PreviewProvider {
    static var previews: some View {
        SpendingPriorityPicker_PreviewsHelper()
    }
}
