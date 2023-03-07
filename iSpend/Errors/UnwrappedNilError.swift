//
//  UnwrappedNilError.swift
//  iSpend
//
//  Created by Jonas Kaiser on 21.02.23.
//

import Foundation

infix operator ?!: NilCoalescingPrecedence

/// Throws the right hand side error if the left hand side optional is `nil`.
func ?!<T>(value: T?, error: @autoclosure () -> Error) throws -> T {
    guard let value = value else {
        throw error()
    }
    return value
}

enum UnwrappedNilError: Error {
    case unwrapped(String)
}
