//
//  RootView.swift
//  Places
//

import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies

    var body: some View {
        PlacesListView(repository: dependencies.placesRepository)
    }
}

#Preview {
    RootView(dependencies: .live())
}
