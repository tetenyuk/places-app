//
//  AppDependencies.swift
//  Places
//

import Foundation

/// Composition root
struct AppDependencies {
    let placesRepository: any PlacesRepository

    static func live() -> AppDependencies {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let client = URLSessionHTTPClient(session: URLSession(configuration: configuration))
        return AppDependencies(placesRepository: RemotePlacesRepository(client: client, url: .places))
    }
}
