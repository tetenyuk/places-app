//
//  URLSessionHTTPClientTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@Suite("URLSessionHTTPClient", .serialized)
struct URLSessionHTTPClientTests {
    private let client = URLSessionHTTPClient(session: URLProtocolStub.makeSession())

    init() {
        URLProtocolStub.reset()
    }

    @Test("returns the body of a successful response")
    func success() async throws {
        let body = PlaceJSON.data(PlaceJSON.empty)
        URLProtocolStub.stub(statusCode: 200, data: body)

        #expect(try await client.data(from: .places) == body)
    }

    @Test("treats a non-success status as a failed request", arguments: [301, 400, 404, 500])
    func unexpectedStatus(code: Int) async {
        URLProtocolStub.stub(statusCode: code)

        await #expect(throws: PlacesError.requestFailed) {
            try await client.data(from: .places)
        }
    }

    @Test("reports a missing connection as offline", arguments: [
        URLError.notConnectedToInternet,
        .networkConnectionLost,
        .dataNotAllowed,
    ])
    func offline(code: URLError.Code) async {
        URLProtocolStub.stub(error: URLError(code))

        await #expect(throws: PlacesError.offline) {
            try await client.data(from: .places)
        }
    }

    @Test("reports other transport errors as a failed request")
    func otherTransportError() async {
        URLProtocolStub.stub(error: URLError(.timedOut))

        await #expect(throws: PlacesError.requestFailed) {
            try await client.data(from: .places)
        }
    }

    @Test("keeps cancellation distinguishable from a real failure")
    func cancellation() async {
        URLProtocolStub.stub(error: URLError(.cancelled))

        await #expect(throws: CancellationError.self) {
            try await client.data(from: .places)
        }
    }
}
