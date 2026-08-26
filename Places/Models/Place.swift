//
//  Place.swift
//  Places
//

import Foundation

struct Place: Identifiable, Equatable, Sendable {
    let name: String?
    let coordinate: Coordinate

    var id: String { "\(name ?? "")|\(coordinate.latitude)|\(coordinate.longitude)" }

    var displayName: String {
        name ?? String(localized: "place.unnamed", defaultValue: "Unnamed place")
    }
}
