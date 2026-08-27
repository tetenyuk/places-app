//
//  FakePlacesCache.swift
//  PlacesTests
//

import Foundation
@testable import Places

actor FakePlacesCache: PlacesCache {
    private(set) var stored: [Place]?

    init(stored: [Place]? = nil) {
        self.stored = stored
    }

    func load() -> [Place]? { stored }

    func save(_ places: [Place]) { stored = places }
}
