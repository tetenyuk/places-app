//
//  HTTPClientSpy.swift
//  PlacesTests
//

import Foundation
@testable import Places

final class HTTPClientSpy: HTTPClient, @unchecked Sendable {
    private let lock = NSLock()
    private let result: Result<Data, any Error>
    private var _requestedURLs: [URL] = []

    var requestedURLs: [URL] {
        lock.withLock { _requestedURLs }
    }

    init(result: Result<Data, any Error>) {
        self.result = result
    }

    convenience init(json: String) {
        self.init(result: .success(Data(json.utf8)))
    }

    func data(from url: URL) async throws -> Data {
        lock.withLock { _requestedURLs.append(url) }
        return try result.get()
    }
}
