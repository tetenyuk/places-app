//
//  FakePlacesRepository.swift
//  PlacesTests
//

import Foundation
@testable import Places

struct FakePlacesRepository: PlacesRepository, @unchecked Sendable {
    let result: Result<[Place], any Error>

    init(_ result: Result<[Place], any Error>) {
        self.result = result
    }

    init(_ places: [Place]) {
        self.init(.success(places))
    }

    func places() async throws -> [Place] {
        try result.get()
    }
}

extension Place {
    static func stub(name: String? = "Amsterdam", latitude: Double = 52.3547498, longitude: Double = 4.8339215) -> Place {
        Place(name: name, coordinate: Coordinate(latitude: latitude, longitude: longitude)!)
    }
}
