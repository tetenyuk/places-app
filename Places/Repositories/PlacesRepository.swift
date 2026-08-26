//
//  PlacesRepository.swift
//  Places
//

import Foundation

protocol PlacesRepository: Sendable {
    func places() async throws -> [Place]
}
