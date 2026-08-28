//
//  PlaceAccessibilityTests.swift
//  PlacesTests
//

import Testing
@testable import Places

@Suite("Place accessibility")
struct PlaceAccessibilityTests {
    @Test("names the place and both coordinates")
    func namedPlace() {
        let label = Place.stub(name: "Amsterdam").accessibilityLabel

        #expect(label.contains("Amsterdam"))
        #expect(label.contains("latitude"))
        #expect(label.contains("longitude"))
    }

    @Test("a place without a name is still announced by something")
    func unnamedPlace() {
        let label = Place.stub(name: nil).accessibilityLabel

        #expect(label.contains(Place.stub(name: nil).displayName))
        #expect(!label.hasPrefix(","))
    }

    @Test("rounds coordinates down to what is worth hearing")
    func spokenPrecision() {
        let label = Place.stub(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215).accessibilityLabel

        #expect(!label.contains("52.3547498"))
        #expect(!label.contains("4.8339215"))
    }
}
