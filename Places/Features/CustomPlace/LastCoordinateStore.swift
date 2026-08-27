//
//  LastCoordinateStore.swift
//  Places
//

import Foundation

struct LastCoordinateStore {
    private enum Key {
        static let latitude = "lastEnteredLatitude"
        static let longitude = "lastEnteredLongitude"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var latitude: String { defaults.string(forKey: Key.latitude) ?? "" }

    var longitude: String { defaults.string(forKey: Key.longitude) ?? "" }

    func save(latitude: String, longitude: String) {
        defaults.set(latitude, forKey: Key.latitude)
        defaults.set(longitude, forKey: Key.longitude)
    }
}
