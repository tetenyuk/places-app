//
//  RemotePlacesRepository.swift
//  Places
//

import Foundation

struct RemotePlacesRepository: PlacesRepository {
    private let client: HTTPClient
    private let url: URL

    init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }

    /// Invalid entries are dropped, not fatal
    func places() async throws -> [Place] {
        let data = try await client.data(from: url)
        guard let response = try? JSONDecoder().decode(PlacesResponse.self, from: data) else {
            throw PlacesError.invalidData
        }
        return response.locations.compactMap(Place.init(dto:))
    }
}
