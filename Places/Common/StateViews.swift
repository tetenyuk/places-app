//
//  StateViews.swift
//  Places
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "mappin.slash")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No places to show")
                .font(.headline)
        }
        .padding()
    }
}

struct ErrorStateView: View {
    let error: PlacesError
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            if let title = error.errorDescription {
                Text(title)
                    .font(.headline)
            }
            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            Button("Try again", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct CachedPlacesBanner: View {
    var body: some View {
        Label("Offline — showing saved places", systemImage: "wifi.slash")
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(8)
            .background(Color.yellow.opacity(0.2))
    }
}

#Preview("Empty") {
    EmptyStateView()
}

#Preview("Error") {
    ErrorStateView(error: .offline) {}
}

#Preview("Cached") {
    CachedPlacesBanner()
}
