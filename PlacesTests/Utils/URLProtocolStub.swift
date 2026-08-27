//
//  URLProtocolStub.swift
//  PlacesTests
//

import Foundation
@testable import Places

final class URLProtocolStub: URLProtocol, @unchecked Sendable {
    struct Stub {
        var data: Data?
        var response: URLResponse?
        var error: (any Error)?
    }

    private static let lock = NSLock()
    nonisolated(unsafe) private static var current: Stub?

    static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: configuration)
    }

    static func stub(data: Data? = nil, response: URLResponse? = nil, error: (any Error)? = nil) {
        lock.withLock { current = Stub(data: data, response: response, error: error) }
    }

    static func stub(statusCode: Int, data: Data = Data()) {
        stub(data: data, response: HTTPURLResponse(url: .places, statusCode: statusCode, httpVersion: nil, headerFields: nil))
    }

    static func reset() {
        lock.withLock { current = nil }
    }

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let stub = Self.lock.withLock { Self.current }
        if let error = stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        if let response = stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let data = stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
