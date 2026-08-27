//
//  PlacesCache.swift
//  Places
//

import Foundation

protocol PlacesCache: Sendable {
    func load() async -> [Place]?
    func save(_ places: [Place]) async
}
