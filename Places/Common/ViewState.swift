//
//  ViewState.swift
//  Places
//

import Foundation

/// The complete state of a screen that loads its content asynchronously.
enum ViewState<Value> {
    case loading
    case loaded(Value)
    case failed(PlacesError)
}

extension ViewState {
    /// The loaded content, or `nil` while loading or after a failure.
    var value: Value? {
        guard case let .loaded(value) = self else { return nil }
        return value
    }

    /// The failure, or `nil` when the screen is loading or loaded.
    var error: PlacesError? {
        guard case let .failed(error) = self else { return nil }
        return error
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

extension ViewState: Equatable where Value: Equatable {}
extension ViewState: Sendable where Value: Sendable {}
