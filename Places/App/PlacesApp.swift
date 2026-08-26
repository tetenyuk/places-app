//
//  PlacesApp.swift
//  Places
//

import SwiftUI

@main
struct PlacesApp: App {
    private let dependencies = AppDependencies.live()

    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
}
