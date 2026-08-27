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
    private func makeViewModel(
        _ repository: FakePlacesRepository,
        opener: URLOpenerSpy = URLOpenerSpy()
    ) -> PlacesListViewModel {
        PlacesListViewModel(repository: repository, urlOpener: opener)
    }

    @Test("starts out loading")
    func initialState() {
        #expect(makeViewModel(FakePlacesRepository([])).state.isLoading)
    }

    @Test("publishes what the repository returns")
    func loadsPlaces() async {
        let places = [Place.stub(), .stub(name: nil)]
        let viewModel = makeViewModel(FakePlacesRepository(places))

        await viewModel.load()

        #expect(viewModel.state.value == places)
    }

    @Test("an empty list is loaded, not an error")
    func loadsEmptyList() async {
        let viewModel = makeViewModel(FakePlacesRepository([]))

        await viewModel.load()

        #expect(viewModel.state.value == [])
        #expect(viewModel.state.error == nil)
    }

    @Test("surfaces a known failure as it is")
    func knownFailure() async {
        let viewModel = makeViewModel(FakePlacesRepository(.failure(PlacesError.offline)))

        await viewModel.load()

        #expect(viewModel.state.error == .offline)
    }

    @Test("falls back to a request failure for anything unrecognised")
    func unknownFailure() async {
        let viewModel = makeViewModel(FakePlacesRepository(.failure(URLError(.badServerResponse))))

        await viewModel.load()

        #expect(viewModel.state.error == .requestFailed)
    }

    @Test("cancellation leaves the state untouched")
    func cancellationKeepsState() async {
        let viewModel = makeViewModel(FakePlacesRepository(.failure(CancellationError())))

        await viewModel.load()

        #expect(viewModel.state.isLoading)
    }

    @Test("selecting a place opens its wikipedia deep link")
    func selectOpensDeepLink() async {
        let opener = URLOpenerSpy()
        let viewModel = makeViewModel(FakePlacesRepository([]), opener: opener)

        await viewModel.select(.stub())

        #expect(opener.openedURLs.map(\.absoluteString) == ["wikipedia://places?lat=52.3547498&lon=4.8339215"])
        #expect(!viewModel.wikipediaUnavailable)
    }

    @Test("warns when nothing can open the deep link")
    func selectWithoutWikipedia() async {
        let viewModel = makeViewModel(FakePlacesRepository([]), opener: URLOpenerSpy(succeeds: false))

        await viewModel.select(.stub())

        #expect(viewModel.wikipediaUnavailable)
    }
}
