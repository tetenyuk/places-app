//
//  CustomPlaceView.swift
//  Places
//

import SwiftUI

struct CustomPlaceView: View {
    @StateObject private var viewModel: CustomPlaceViewModel
    @Environment(\.dismiss) private var dismiss

    init(urlOpener: any URLOpener, store: LastCoordinateStore) {
        _viewModel = StateObject(wrappedValue: CustomPlaceViewModel(urlOpener: urlOpener, store: store))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    field("Latitude", text: $viewModel.latitude, isInvalid: viewModel.latitudeIsInvalid, hint: "Between -90 and 90")
                    field("Longitude", text: $viewModel.longitude, isInvalid: viewModel.longitudeIsInvalid, hint: "Between -180 and 180")
                }
                Section {
                    Button("Open in Wikipedia") {
                        Task { await viewModel.open() }
                    }
                    .disabled(!viewModel.canOpen)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Custom place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert(
                PlacesError.wikipediaUnavailable.errorDescription ?? "",
                isPresented: $viewModel.wikipediaUnavailable
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(PlacesError.wikipediaUnavailable.recoverySuggestion ?? "")
            }
        }
    }

    @ViewBuilder
    private func field(_ title: String, text: Binding<String>, isInvalid: Bool, hint: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(title, text: text)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.go)
            if isInvalid {
                Text(hint)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    CustomPlaceView(urlOpener: UIApplicationURLOpener(), store: LastCoordinateStore())
}
