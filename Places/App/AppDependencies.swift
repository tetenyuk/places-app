//
//  AppDependencies.swift
//  Places
//

import Foundation

/// Composition root: the single place where protocols are bound to concrete implementations.
struct AppDependencies {
    static func live() -> AppDependencies {
        AppDependencies()
    }
}
