//
//  CoordinateParser.swift
//  Places
//

import Foundation

enum CoordinateParser {
    static func latitude(from text: String) -> Double? {
        value(from: text, in: -90...90)
    }

    static func longitude(from text: String) -> Double? {
        value(from: text, in: -180...180)
    }

    /// Typing a comma is natural on a lot of keyboards, so it is accepted and normalised away
    private static func value(from text: String, in range: ClosedRange<Double>) -> Double? {
        let normalised = text
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalised), range.contains(value) else { return nil }
        return value
    }
}
