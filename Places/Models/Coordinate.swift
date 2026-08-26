//
//  Coordinate.swift
//  Places
//

import Foundation

struct Coordinate: Equatable, Sendable {
    let latitude: Double
    let longitude: Double

    init?(latitude: Double, longitude: Double) {
        guard (-90...90).contains(latitude), (-180...180).contains(longitude) else { return nil }
        self.latitude = latitude
        self.longitude = longitude
    }
}
