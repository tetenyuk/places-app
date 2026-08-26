//
//  PlacesListViewModel.swift
//  Places
//

import Combine
import Foundation

@MainActor
final class PlacesListViewModel: ObservableObject {
    @Published private(set) var state: ViewState<[Place]> = .loading

    private let repository: any PlacesRepository

    init(repository: any PlacesRepository) {
        self.repository = repository
    }

    func load() async {
        state = .loading
        await reload()
    }

    /// Keeps the current list on screen while the new one is fetched
    func refresh() async {
        await reload()
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
