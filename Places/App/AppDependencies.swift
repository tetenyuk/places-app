//
//  AppDependencies.swift
//  Places
//

import Foundation

/// Composition root
struct AppDependencies {
    let placesRepository: any PlacesRepository

    static func live() -> AppDependencies {
        AppDependencies(placesRepository: StaticPlacesRepository())
    }
}
