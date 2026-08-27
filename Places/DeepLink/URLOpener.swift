//
//  URLOpener.swift
//  Places
//

import UIKit

@MainActor
protocol URLOpener {
    /// False when no installed app handles the url
    func open(_ url: URL) async -> Bool
}

struct UIApplicationURLOpener: URLOpener {
    func open(_ url: URL) async -> Bool {
        await UIApplication.shared.open(url)
    }
}
