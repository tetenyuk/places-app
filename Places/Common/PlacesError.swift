//
//  PlacesError.swift
//  Places
//

import Foundation

/// Every failure the app can surface to the user.
nonisolated enum PlacesError: Error, Equatable {
    /// The device has no usable network connection.
    case offline

    /// The request could not be completed, or the server answered with an unexpected status.
    case requestFailed

    /// The response was received but did not match the expected format.
    case invalidData

    /// The modified Wikipedia app is not installed, so the deep link could not be opened.
    case wikipediaUnavailable
}

extension PlacesError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .offline:
            String(localized: "error.offline.title", defaultValue: "No internet connection")
        case .requestFailed:
            String(localized: "error.requestFailed.title", defaultValue: "Couldn’t load places")
        case .invalidData:
            String(localized: "error.invalidData.title", defaultValue: "Unexpected response")
        case .wikipediaUnavailable:
            String(localized: "error.wikipediaUnavailable.title", defaultValue: "Wikipedia isn’t installed")
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .offline:
            String(localized: "error.offline.suggestion", defaultValue: "Check your connection and try again.")
        case .requestFailed:
            String(localized: "error.requestFailed.suggestion", defaultValue: "Please try again in a moment.")
        case .invalidData:
            String(localized: "error.invalidData.suggestion", defaultValue: "The places list is unavailable right now.")
        case .wikipediaUnavailable:
            String(localized: "error.wikipediaUnavailable.suggestion", defaultValue: "Install Wikipedia and try again later.")
        }
    }
}
