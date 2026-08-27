//
//  URLOpenerSpy.swift
//  PlacesTests
//

import Foundation
@testable import Places

@MainActor
final class URLOpenerSpy: URLOpener {
    private(set) var openedURLs: [URL] = []
    private let succeeds: Bool

    init(succeeds: Bool = true) {
        self.succeeds = succeeds
    }

    func open(_ url: URL) async -> Bool {
        openedURLs.append(url)
        return succeeds
    }
}
