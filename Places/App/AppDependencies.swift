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
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains(uiTestingArgument) {
            return uiTesting()
        }
        #endif
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
    static let uiTestingArgument = "-uiTesting"

    static func preview() -> AppDependencies {
        AppDependencies(
            placesRepository: StaticPlacesRepository(),
            placesCache: FilePlacesCache.inCachesDirectory(),
            urlOpener: UIApplicationURLOpener(),
            lastCoordinateStore: LastCoordinateStore()
        )
    }

    /// Canned places and throwaway storage, so UI tests do not depend on the network or on what a previous run left behind
    static func uiTesting() -> AppDependencies {
        let suite = "uiTesting"
        let defaults = UserDefaults(suiteName: suite)!
        defaults.removePersistentDomain(forName: suite)
        let cacheURL = FileManager.default.temporaryDirectory.appendingPathComponent("ui-testing-places.json")
        try? FileManager.default.removeItem(at: cacheURL)
        return AppDependencies(
            placesRepository: StaticPlacesRepository(),
            placesCache: FilePlacesCache(url: cacheURL),
            urlOpener: UnavailableURLOpener(),
            lastCoordinateStore: LastCoordinateStore(defaults: defaults)
        )
    }
}
#endif
