//
//  Date.swift
//  iSpend
//
//  Created by Jonas Kaiser on 14.02.23.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    static func by(day: Int, month: Int, year: Int) -> Date {
        let date = Date()
        var dateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: date)

        dateComponents.day = day
        dateComponents.month = month
        dateComponents.year = year

        return Calendar.current.date(from: dateComponents)!
    }
}
