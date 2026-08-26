//
//  RootView.swift
//  Places
//

import SwiftUI

struct RootView: View {
    let dependencies: AppDependencies

    var body: some View {
        Text("Places")
    }
}

#Preview {
    RootView(dependencies: .live())
}
