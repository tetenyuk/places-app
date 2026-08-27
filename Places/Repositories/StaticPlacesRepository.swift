//
//  StaticPlacesRepository.swift
//  Places
//

import Foundation

#if DEBUG
/// Previews only
struct StaticPlacesRepository: PlacesRepository {
    func places() async throws -> [Place] {
        [
            Place(name: "Amsterdam", coordinate: Coordinate(latitude: 52.3547498, longitude: 4.8339215)!),
            Place(name: "Mumbai", coordinate: Coordinate(latitude: 19.0823998, longitude: 72.8111468)!),
            Place(name: "Copenhagen", coordinate: Coordinate(latitude: 55.6713442, longitude: 12.523785)!),
            Place(name: nil, coordinate: Coordinate(latitude: 40.4380638, longitude: -3.7495758)!),
        ]
    }
}
#endif
