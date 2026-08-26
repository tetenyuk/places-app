//
//  PlaceTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@Suite("Place")
struct PlaceTests {
    private func place(name: String?) -> Place {
        Place(name: name, coordinate: Coordinate(latitude: 40.4380638, longitude: -3.7495758)!)
    }

    @Test("a named place shows its name")
    func namedPlace() {
        #expect(place(name: "Madrid").displayName == "Madrid")
    }

    @Test("a place without a name still has something to show")
    func unnamedPlace() {
        let displayName = place(name: nil).displayName

        #expect(!displayName.isEmpty)
        #expect(displayName != "nil")
    }

    @Test("the id stays the same across separately decoded copies")
    func stableIdentity() {
        #expect(place(name: "Madrid").id == place(name: "Madrid").id)
        #expect(place(name: "Madrid").id != place(name: nil).id)
    }
}
