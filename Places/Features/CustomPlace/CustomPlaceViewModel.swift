//
//  CustomPlaceViewModel.swift
//  Places
//

import Combine
import Foundation

@MainActor
final class CustomPlaceViewModel: ObservableObject {
    @Published var latitude: String
    @Published var longitude: String
    @Published var wikipediaUnavailable = false

    private let urlOpener: any URLOpener
    private let store: LastCoordinateStore

    init(urlOpener: any URLOpener, store: LastCoordinateStore) {
        self.urlOpener = urlOpener
        self.store = store
        latitude = store.latitude
        longitude = store.longitude
    }

    var coordinate: Coordinate? {
        guard let latitude = CoordinateParser.latitude(from: latitude),
              let longitude = CoordinateParser.longitude(from: longitude)
        else { return nil }
        return Coordinate(latitude: latitude, longitude: longitude)
    }

    /// Only complains about what the user has actually typed
    var latitudeIsInvalid: Bool {
        !latitude.isEmpty && CoordinateParser.latitude(from: latitude) == nil
    }

    var longitudeIsInvalid: Bool {
        !longitude.isEmpty && CoordinateParser.longitude(from: longitude) == nil
    }

    var canOpen: Bool { coordinate != nil }

    func open() async {
        guard let coordinate else { return }
        store.save(latitude: latitude, longitude: longitude)
        let opened = await urlOpener.open(WikipediaDeepLink.url(for: coordinate))
        wikipediaUnavailable = !opened
    }
}
