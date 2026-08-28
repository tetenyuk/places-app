//
//  StateViews.swift
//  Places
//

import SwiftUI
import UIKit

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
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("emptyState")
    }
}

struct ErrorStateView: View {
    let error: PlacesError
    let retry: () -> Void

    @AccessibilityFocusState private var isMessageFocused: Bool

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            message
            Button("Try again", action: retry)
                .buttonStyle(.borderedProminent)
                .accessibilityIdentifier("retry")
        }
        .padding()
        .accessibilityIdentifier("errorState")
        .onAppear { isMessageFocused = true }
    }

    /// One element so VoiceOver reads the failure and the way out in a single stop
    private var message: some View {
        VStack(spacing: 8) {
            if let title = error.errorDescription {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityFocused($isMessageFocused)
    }
}

struct CachedPlacesBanner: View {
    private var text: String {
        String(localized: "banner.cachedPlaces", defaultValue: "Offline — showing saved places")
    }

    var body: some View {
        Label(text, systemImage: "wifi.slash")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(Color.yellow.opacity(0.2))
            .accessibilityElement(children: .combine)
            .accessibilityIdentifier("cachedPlacesBanner")
            .onAppear {
                UIAccessibility.post(notification: .announcement, argument: text)
            }
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
