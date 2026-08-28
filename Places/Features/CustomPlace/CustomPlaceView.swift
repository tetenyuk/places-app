//
//  CustomPlaceView.swift
//  Places
//

import SwiftUI

struct CustomPlaceView: View {
    private enum Field {
        case latitude, longitude
    }

    @StateObject private var viewModel: CustomPlaceViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    init(urlOpener: any URLOpener, store: LastCoordinateStore) {
        _viewModel = StateObject(wrappedValue: CustomPlaceViewModel(urlOpener: urlOpener, store: store))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    field(
                        "Latitude",
                        text: $viewModel.latitude,
                        field: .latitude,
                        isInvalid: viewModel.latitudeIsInvalid,
                        hint: "Between -90 and 90",
                        identifier: "latitudeField"
                    )
                    field(
                        "Longitude",
                        text: $viewModel.longitude,
                        field: .longitude,
                        isInvalid: viewModel.longitudeIsInvalid,
                        hint: "Between -180 and 180",
                        identifier: "longitudeField"
                    )
                }
                Section {
                    Button("Open in Wikipedia") {
                        Task { await viewModel.open() }
                    }
                    .disabled(!viewModel.canOpen)
                    .accessibilityIdentifier("openInWikipedia")
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Custom place")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("cancelCustomPlace")
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

    /// The range hint doubles as the field's accessibility hint so it is heard, not only seen
    private func field(
        _ title: String,
        text: Binding<String>,
        field: Field,
        isInvalid: Bool,
        hint: String,
        identifier: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(title, text: text)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(field == .latitude ? .next : .go)
                .focused($focusedField, equals: field)
                .onSubmit { focusedField = field == .latitude ? .longitude : nil }
                .accessibilityLabel(title)
                .accessibilityHint(hint)
                .accessibilityIdentifier(identifier)
            if isInvalid {
                Text(hint)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .accessibilityHidden(true)
            }
        }
    }
}

#Preview {
    CustomPlaceView(urlOpener: UIApplicationURLOpener(), store: LastCoordinateStore())
}
