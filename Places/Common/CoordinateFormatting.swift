//
//  CoordinateFormatting.swift
//  Places
//

import Foundation

extension Coordinate {
    /// Locale-aware, for display only — deep links build their own POSIX string
    var formatted: String {
        let style = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(4))
        return "\(latitude.formatted(style)), \(longitude.formatted(style))"
    }
}
