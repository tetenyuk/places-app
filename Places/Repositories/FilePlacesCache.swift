//
//  FilePlacesCache.swift
//  Places
//

import Foundation

/// An actor so the file work never lands on the main thread
actor FilePlacesCache: PlacesCache {
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    static func inCachesDirectory() -> FilePlacesCache {
        let directory = URL.cachesDirectory
        return FilePlacesCache(url: directory.appendingPathComponent("places.json"))
    }

    func load() -> [Place]? {
        guard let data = try? Data(contentsOf: url),
              let response = try? JSONDecoder().decode(PlacesResponse.self, from: data)
        else { return nil }
        return response.locations.compactMap(Place.init(dto:))
    }

    func save(_ places: [Place]) {
        let response = PlacesResponse(locations: places.map(PlaceDTO.init(place:)))
        guard let data = try? JSONEncoder().encode(response) else { return }
        try? data.write(to: url, options: .atomic)
    }
}

extension URL {
    static var cachesDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
}
