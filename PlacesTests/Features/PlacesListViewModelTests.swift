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
        cache: FakePlacesCache = FakePlacesCache(),
        opener: URLOpenerSpy = URLOpenerSpy()
    ) -> PlacesListViewModel {
        PlacesListViewModel(repository: repository, cache: cache, urlOpener: opener)
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

    @Test("keeps a copy of every successful load")
    func fillsTheCache() async {
        let places = [Place.stub()]
        let cache = FakePlacesCache()

        await makeViewModel(FakePlacesRepository(places), cache: cache).load()

        #expect(await cache.stored == places)
    }

    @Test("falls back to the cache when the device is offline")
    func offlineFallsBackToCache() async {
        let cached = [Place.stub()]
        let viewModel = makeViewModel(
            FakePlacesRepository(.failure(PlacesError.offline)),
            cache: FakePlacesCache(stored: cached)
        )

        await viewModel.load()

        #expect(viewModel.state.value == cached)
        #expect(viewModel.isShowingCachedPlaces)
    }

    @Test("offline with nothing cached is still an error")
    func offlineWithoutCache() async {
        let viewModel = makeViewModel(FakePlacesRepository(.failure(PlacesError.offline)))

        await viewModel.load()

        #expect(viewModel.state.error == .offline)
        #expect(!viewModel.isShowingCachedPlaces)
    }

    @Test("only offline gets the cached answer")
    func otherFailuresIgnoreCache() async {
        let viewModel = makeViewModel(
            FakePlacesRepository(.failure(PlacesError.invalidData)),
            cache: FakePlacesCache(stored: [Place.stub()])
        )

        await viewModel.load()

        #expect(viewModel.state.error == .invalidData)
    }

    @Test("a successful reload clears the offline banner")
    func reloadClearsBanner() async {
        let cache = FakePlacesCache(stored: [Place.stub()])
        let viewModel = makeViewModel(FakePlacesRepository(.failure(PlacesError.offline)), cache: cache)
        await viewModel.load()
        #expect(viewModel.isShowingCachedPlaces)

        let recovered = makeViewModel(FakePlacesRepository([Place.stub(name: "Mumbai")]), cache: cache)
        await recovered.load()

        #expect(!recovered.isShowingCachedPlaces)
    }
}
