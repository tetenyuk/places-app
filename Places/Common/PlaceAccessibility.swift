//
//  PlaceAccessibility.swift
//  Places
//

import Foundation

extension Coordinate {
    /// Two decimals is as much as is worth hearing
    var spoken: String {
        let style = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
        return String(
            localized: "coordinate.spoken",
            defaultValue: "latitude \(latitude.formatted(style)), longitude \(longitude.formatted(style))"
        )
    }
}

extension Place {
    var accessibilityLabel: String {
        "\(displayName), \(coordinate.spoken)"
    }
}
