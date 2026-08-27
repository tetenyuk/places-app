//
//  RootView.swift
//  Places
//

import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies

    var body: some View {
        PlacesListView(repository: dependencies.placesRepository, urlOpener: dependencies.urlOpener)
    }
}

#Preview {
    RootView(dependencies: .live())
}
