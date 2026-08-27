//
//  FilePlacesCacheTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@Suite("FilePlacesCache")
struct FilePlacesCacheTests {
    private func makeCache() -> FilePlacesCache {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("places-cache-\(UUID().uuidString).json")
        return FilePlacesCache(url: url)
    }

    @Test("has nothing to give before anything is saved")
    func emptyCache() async {
        #expect(await makeCache().load() == nil)
    }

    @Test("gives back what was saved, unnamed places included")
    func roundTrip() async {
        let cache = makeCache()
        let places = [Place.stub(), .stub(name: nil, latitude: 40.4380638, longitude: -3.7495758)]

        await cache.save(places)

        #expect(await cache.load() == places)
    }

    @Test("the newest save wins")
    func overwrites() async {
        let cache = makeCache()

        await cache.save([Place.stub()])
        await cache.save([])

        #expect(await cache.load() == [])
    }
}
