//
//  URLSessionHTTPClient.swift
//  Places
//

import Foundation

struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func data(from url: URL) async throws -> Data {
        do {
            let (data, response) = try await session.data(from: url)
            guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                throw PlacesError.requestFailed
            }
            return data
        } catch let error as URLError {
            throw Self.mapped(error)
        }
    }

    /// Cancellation is not a user-facing failure
    private static func mapped(_ error: URLError) -> any Error {
        switch error.code {
        case .cancelled:
            CancellationError()
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            PlacesError.offline
        default:
            PlacesError.requestFailed
        }
    }
}
