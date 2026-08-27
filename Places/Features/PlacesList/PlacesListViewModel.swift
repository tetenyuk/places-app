//
//  PlacesListViewModel.swift
//  Places
//

import Combine
import Foundation

@MainActor
final class PlacesListViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Place]> = .loading
    @Published private(set) var isShowingCachedPlaces = false
    @Published var wikipediaUnavailable = false

    private let repository: any PlacesRepository
    private let cache: any PlacesCache
    private let urlOpener: any URLOpener

    init(repository: any PlacesRepository, cache: any PlacesCache, urlOpener: any URLOpener) {
        self.repository = repository
        self.cache = cache
        self.urlOpener = urlOpener
    }

    func load() async {
        state = .loading
        await reload()
    }

    /// Keeps the current list on screen while the new one is fetched
    func refresh() async {
        await reload()
    }

    func select(_ place: Place) async {
        let opened = await urlOpener.open(WikipediaDeepLink.url(for: place.coordinate))
        wikipediaUnavailable = !opened
    }

    private func reload() async {
        do {
            let places = try await repository.places()
            await cache.save(places)
            isShowingCachedPlaces = false
            state = .loaded(places)
        } catch is CancellationError {
            return
        } catch {
            await handle(error as? PlacesError ?? .requestFailed)
        }
    }

    /// Offline is the only failure worth answering with stale data
    private func handle(_ error: PlacesError) async {
        guard error == .offline, let cached = await cache.load(), !cached.isEmpty else {
            isShowingCachedPlaces = false
            state = .failed(error)
            return
        }
        isShowingCachedPlaces = true
        state = .loaded(cached)
    }
}
