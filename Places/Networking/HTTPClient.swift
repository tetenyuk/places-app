//
//  HTTPClient.swift
//  Places
//

import Foundation

protocol HTTPClient: Sendable {
    func data(from url: URL) async throws -> Data
}
