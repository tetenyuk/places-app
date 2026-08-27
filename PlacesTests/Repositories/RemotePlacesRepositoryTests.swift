//
//  RemotePlacesRepositoryTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@Suite("RemotePlacesRepository")
struct RemotePlacesRepositoryTests {
    private func makeRepository(_ client: HTTPClientSpy) -> RemotePlacesRepository {
        RemotePlacesRepository(client: client, url: .places)
    }

    @Test("requests the url it was given")
    func requestsGivenURL() async throws {
        let client = HTTPClientSpy(json: PlaceJSON.empty)

        _ = try await makeRepository(client).places()

        #expect(client.requestedURLs == [.places])
    }

    @Test("decodes the assignment payload")
    func decodesPayload() async throws {
        let places = try await makeRepository(HTTPClientSpy(json: PlaceJSON.locations)).places()

        #expect(places.count == 4)
        #expect(places.map(\.name) == ["Amsterdam", "Mumbai", "Copenhagen", nil])
        #expect(places[0].coordinate == Coordinate(latitude: 52.3547498, longitude: 4.8339215))
        #expect(places[3].coordinate == Coordinate(latitude: 40.4380638, longitude: -3.7495758))
    }

    @Test("an empty list is a success, not a failure")
    func emptyList() async throws {
        let places = try await makeRepository(HTTPClientSpy(json: PlaceJSON.empty)).places()

        #expect(places.isEmpty)
    }

    @Test("drops entries with impossible coordinates instead of failing the whole list")
    func dropsInvalidEntries() async throws {
        let places = try await makeRepository(HTTPClientSpy(json: PlaceJSON.outOfRangeCoordinates)).places()

        #expect(places.map(\.name) == ["Valid"])
    }

    @Test("reports unreadable payloads as invalid data", arguments: [
        PlaceJSON.unexpectedShape,
        PlaceJSON.notJSON,
    ])
    func invalidPayload(json: String) async {
        await #expect(throws: PlacesError.invalidData) {
            try await makeRepository(HTTPClientSpy(json: json)).places()
        }
    }

    @Test("passes transport failures through untouched")
    func transportFailure() async {
        let client = HTTPClientSpy(result: .failure(PlacesError.offline))

        await #expect(throws: PlacesError.offline) {
            try await makeRepository(client).places()
        }
    }
}
