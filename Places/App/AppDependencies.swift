//
//  AppDependencies.swift
//  Places
//

import Foundation

/// Composition root
struct AppDependencies {
    let placesRepository: any PlacesRepository
    let placesCache: any PlacesCache
    let urlOpener: any URLOpener
    let lastCoordinateStore: LastCoordinateStore

    static func live() -> AppDependencies {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let client = URLSessionHTTPClient(session: URLSession(configuration: configuration))
        return AppDependencies(
            placesRepository: RemotePlacesRepository(client: client, url: .places),
            placesCache: FilePlacesCache.inCachesDirectory(),
            urlOpener: UIApplicationURLOpener(),
            lastCoordinateStore: LastCoordinateStore()
        )
    }
}

#if DEBUG
extension AppDependencies {
    static func preview() -> AppDependencies {
        AppDependencies(
            placesRepository: StaticPlacesRepository(),
            placesCache: FilePlacesCache.inCachesDirectory(),
            urlOpener: UIApplicationURLOpener(),
            lastCoordinateStore: LastCoordinateStore()
        )
    }
}
#endif
