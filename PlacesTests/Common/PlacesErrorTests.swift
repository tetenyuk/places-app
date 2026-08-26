//
//  PlacesErrorTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@Suite("PlacesError")
struct PlacesErrorTests {
    @Test("every case carries a description and a recovery suggestion", arguments: [
        PlacesError.offline,
        .requestFailed,
        .invalidData,
        .wikipediaUnavailable,
    ])
    func userFacingText(error: PlacesError) {
        #expect(error.errorDescription?.isEmpty == false)
        #expect(error.recoverySuggestion?.isEmpty == false)
        #expect(error.localizedDescription.contains("couldn’t be completed") == false)
    }
}
