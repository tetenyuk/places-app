//
//  ViewStateTests.swift
//  PlacesTests
//

import Testing
@testable import Places

@Suite("ViewState")
struct ViewStateTests {
    @Test("loading exposes neither a value nor an error")
    func loading() {
        let state = ViewState<[Int]>.loading

        #expect(state.isLoading)
        #expect(state.value == nil)
        #expect(state.error == nil)
    }

    @Test("loaded exposes its value and no error")
    func loaded() {
        let state = ViewState.loaded([1, 2, 3])

        #expect(!state.isLoading)
        #expect(state.value == [1, 2, 3])
        #expect(state.error == nil)
    }

    @Test("an empty result is loaded, not a failure")
    func loadedEmpty() {
        let state = ViewState.loaded([Int]())

        #expect(state.value == [])
        #expect(state.error == nil)
    }

    @Test("failed exposes its error and no value")
    func failed() {
        let state = ViewState<[Int]>.failed(.offline)

        #expect(!state.isLoading)
        #expect(state.value == nil)
        #expect(state.error == .offline)
    }
}
