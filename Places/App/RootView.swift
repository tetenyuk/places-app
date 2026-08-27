//
//  RootView.swift
//  Places
//

import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies

    var body: some View {
        PlacesListView(dependencies: dependencies)
    }
}

#Preview {
    RootView(dependencies: .preview())
}
