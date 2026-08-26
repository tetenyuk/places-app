//
//  PlacesListViewModelTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@MainActor
@Suite("PlacesListViewModel")
struct PlacesListViewModelTests {
    @Test("starts out loading")
    func initialState() {
        let viewModel = PlacesListViewModel(repository: FakePlacesRepository([]))

        #expect(viewModel.state.isLoading)
    }

    @Test("publishes what the repository returns")
    func loadsPlaces() async {
        let places = [Place.stub(), .stub(name: nil)]
        let viewModel = PlacesListViewModel(repository: FakePlacesRepository(places))

        await viewModel.load()

        #expect(viewModel.state.value == places)
    }

    @Test("an empty list is loaded, not an error")
    func loadsEmptyList() async {
        let viewModel = PlacesListViewModel(repository: FakePlacesRepository([]))

        await viewModel.load()

        #expect(viewModel.state.value == [])
        #expect(viewModel.state.error == nil)
    }

    @Test("surfaces a known failure as it is")
    func knownFailure() async {
        let viewModel = PlacesListViewModel(repository: FakePlacesRepository(.failure(PlacesError.offline)))

        await viewModel.load()

        #expect(viewModel.state.error == .offline)
    }

    @Test("falls back to a request failure for anything unrecognised")
    func unknownFailure() async {
        let viewModel = PlacesListViewModel(repository: FakePlacesRepository(.failure(URLError(.badServerResponse))))

        await viewModel.load()

        #expect(viewModel.state.error == .requestFailed)
    }

    @Test("cancellation leaves the state untouched")
    func cancellationKeepsState() async {
        let viewModel = PlacesListViewModel(repository: FakePlacesRepository(.failure(CancellationError())))

        await viewModel.load()

        #expect(viewModel.state.isLoading)
    }
}
