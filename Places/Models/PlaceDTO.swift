//
//  PlaceDTO.swift
//  Places
//

import Foundation

struct PlacesResponse: Decodable {
    let locations: [PlaceDTO]
}

struct PlaceDTO: Decodable {
    let name: String?
    let lat: Double
    let long: Double
}

extension Place {
    init?(dto: PlaceDTO) {
        guard let coordinate = Coordinate(latitude: dto.lat, longitude: dto.long) else { return nil }
        self.init(name: dto.name, coordinate: coordinate)
    }
}
