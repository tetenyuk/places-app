//
//  PlacesListViewModel.swift
//  Places
//

import Combine
import Foundation

@MainActor
final class PlacesListViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Place]> = .loading
    @Published var wikipediaUnavailable = false

    private let repository: any PlacesRepository
    private let urlOpener: any URLOpener

    init(repository: any PlacesRepository, urlOpener: any URLOpener) {
        self.repository = repository
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
            state = .loaded(try await repository.places())
        } catch is CancellationError {
            return
        } catch {
            state = .failed(error as? PlacesError ?? .requestFailed)
        }
    }
}
