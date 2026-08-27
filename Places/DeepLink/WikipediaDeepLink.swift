//
//  WikipediaDeepLink.swift
//  Places
//

import Foundation

enum WikipediaDeepLink {
    /// The fork parses `lat` and `lon` with NSScanner in POSIX and requires the whole string to be
    /// a number, so `String(format:)` is used instead of a locale-aware formatter
    static func url(for coordinate: Coordinate) -> URL {
        var components = URLComponents()
        components.scheme = "wikipedia"
        components.host = "places"
        components.queryItems = [
            URLQueryItem(name: "lat", value: formatted(coordinate.latitude)),
            URLQueryItem(name: "lon", value: formatted(coordinate.longitude)),
        ]
        return components.url!
    }

    private static func formatted(_ value: Double) -> String {
        String(format: "%.7f", value)
    }
}
