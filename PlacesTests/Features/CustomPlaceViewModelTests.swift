//
//  CustomPlaceViewModelTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@MainActor
@Suite("CustomPlaceViewModel")
struct CustomPlaceViewModelTests {
    private func makeStore() -> LastCoordinateStore {
        let defaults = UserDefaults(suiteName: "CustomPlaceViewModelTests-\(UUID().uuidString)")!
        return LastCoordinateStore(defaults: defaults)
    }

    private func makeViewModel(
        opener: URLOpenerSpy = URLOpenerSpy(),
        store: LastCoordinateStore? = nil
    ) -> CustomPlaceViewModel {
        CustomPlaceViewModel(urlOpener: opener, store: store ?? makeStore())
    }

    @Test("cannot open until both fields parse")
    func canOpen() {
        let viewModel = makeViewModel()

        #expect(!viewModel.canOpen)

        viewModel.latitude = "52.35"
        #expect(!viewModel.canOpen)

        viewModel.longitude = "4.83"
        #expect(viewModel.canOpen)
    }

    @Test("stays quiet about an empty field")
    func emptyFieldIsNotAnError() {
        let viewModel = makeViewModel()

        #expect(!viewModel.latitudeIsInvalid)
        #expect(!viewModel.longitudeIsInvalid)
    }

    @Test("flags each field on its own range")
    func perFieldValidation() {
        let viewModel = makeViewModel()
        viewModel.latitude = "120"
        viewModel.longitude = "120"

        #expect(viewModel.latitudeIsInvalid)
        #expect(!viewModel.longitudeIsInvalid)
    }

    @Test("opens the deep link for what was typed")
    func opensDeepLink() async {
        let opener = URLOpenerSpy()
        let viewModel = makeViewModel(opener: opener)
        viewModel.latitude = "52,3547498"
        viewModel.longitude = "4.8339215"

        await viewModel.open()

        #expect(opener.openedURLs.map(\.absoluteString) == ["wikipedia://places?lat=52.3547498&lon=4.8339215"])
    }

    @Test("does nothing when the input is incomplete")
    func doesNotOpenInvalidInput() async {
        let opener = URLOpenerSpy()
        let viewModel = makeViewModel(opener: opener)
        viewModel.latitude = "52.35"

        await viewModel.open()

        #expect(opener.openedURLs.isEmpty)
    }

    @Test("warns when nothing can open the deep link")
    func warnsWithoutWikipedia() async {
        let viewModel = makeViewModel(opener: URLOpenerSpy(succeeds: false))
        viewModel.latitude = "52.35"
        viewModel.longitude = "4.83"

        await viewModel.open()

        #expect(viewModel.wikipediaUnavailable)
    }

    @Test("remembers the last coordinates it opened")
    func remembersLastCoordinates() async {
        let store = makeStore()
        let viewModel = makeViewModel(store: store)
        viewModel.latitude = "52.35"
        viewModel.longitude = "4.83"

        await viewModel.open()

        #expect(makeViewModel(store: store).latitude == "52.35")
        #expect(makeViewModel(store: store).longitude == "4.83")
    }
}
