//
//  PlaceDTO.swift
//  Places
//

import Foundation

struct PlacesResponse: Codable {
    let locations: [PlaceDTO]
}

struct PlaceDTO: Codable {
    let name: String?
    let lat: Double
    let long: Double
}

extension PlaceDTO {
    init(place: Place) {
        self.init(name: place.name, lat: place.coordinate.latitude, long: place.coordinate.longitude)
    }
}

extension Place {
    init?(dto: PlaceDTO) {
        guard let coordinate = Coordinate(latitude: dto.lat, longitude: dto.long) else { return nil }
        self.init(name: dto.name, coordinate: coordinate)
    }
}
