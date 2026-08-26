//
//  CoordinateTests.swift
//  PlacesTests
//

import Testing
@testable import Places

@Suite("Coordinate")
struct CoordinateTests {
    @Test("accepts values inside the valid range", arguments: [
        (52.3547498, 4.8339215),
        (0.0, 0.0),
        (90.0, 180.0),
        (-90.0, -180.0),
    ])
    func valid(latitude: Double, longitude: Double) {
        #expect(Coordinate(latitude: latitude, longitude: longitude) != nil)
    }

    @Test("rejects values outside the valid range", arguments: [
        (90.1, 0.0),
        (-90.1, 0.0),
        (0.0, 180.1),
        (0.0, -180.1),
        (Double.nan, 0.0),
        (0.0, Double.infinity),
    ])
    func invalid(latitude: Double, longitude: Double) {
        #expect(Coordinate(latitude: latitude, longitude: longitude) == nil)
    }
}
