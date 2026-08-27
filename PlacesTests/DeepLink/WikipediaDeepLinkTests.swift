//
//  WikipediaDeepLinkTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@Suite("WikipediaDeepLink")
struct WikipediaDeepLinkTests {
    private func url(_ latitude: Double, _ longitude: Double) -> String {
        WikipediaDeepLink.url(for: Coordinate(latitude: latitude, longitude: longitude)!).absoluteString
    }

    @Test("builds the scheme the fork parses")
    func amsterdam() {
        #expect(url(52.3547498, 4.8339215) == "wikipedia://places?lat=52.3547498&lon=4.8339215")
    }

    @Test("keeps negative values")
    func negativeLongitude() {
        #expect(url(40.4380638, -3.7495758) == "wikipedia://places?lat=40.4380638&lon=-3.7495758")
    }

    @Test("pads to a fixed precision instead of dropping digits")
    func fixedPrecision() {
        #expect(url(55.6713442, 12.523785) == "wikipedia://places?lat=55.6713442&lon=12.5237850")
        #expect(url(0, 0) == "wikipedia://places?lat=0.0000000&lon=0.0000000")
    }

    /// A locale-aware formatter would emit `52,3547` or group as `1.234,5` and the fork's scanner would reject it
    @Test("never emits a decimal comma or a grouping separator", arguments: [
        (52.3547498, 4.8339215),
        (-89.9999999, 179.1234567),
        (12.0, -100.5),
    ])
    func plainDecimals(latitude: Double, longitude: Double) {
        let absoluteString = url(latitude, longitude)

        #expect(!absoluteString.contains(","))
        #expect(absoluteString.hasPrefix("wikipedia://places?lat="))
    }
}
