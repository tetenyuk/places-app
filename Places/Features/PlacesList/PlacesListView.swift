//
//  PlacesListView.swift
//  Places
//

import SwiftUI

struct PlacesListView: View {
    @StateObject private var viewModel: PlacesListViewModel

    init(repository: any PlacesRepository, urlOpener: any URLOpener) {
        _viewModel = StateObject(wrappedValue: PlacesListViewModel(repository: repository, urlOpener: urlOpener))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Places")
        }
        .task { await viewModel.load() }
        .alert(
            PlacesError.wikipediaUnavailable.errorDescription ?? "",
            isPresented: $viewModel.wikipediaUnavailable
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(PlacesError.wikipediaUnavailable.recoverySuggestion ?? "")
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let places) where places.isEmpty:
            EmptyStateView()
        case .loaded(let places):
            List(places) { place in
                Button {
                    Task { await viewModel.select(place) }
                } label: {
                    PlaceRow(place: place)
                }
                .buttonStyle(.plain)
            }
            .refreshable { await viewModel.refresh() }
        case .failed(let error):
            ErrorStateView(error: error) {
                Task { await viewModel.load() }
            }
        }
    }
}

#Preview {
    PlacesListView(repository: StaticPlacesRepository(), urlOpener: UIApplicationURLOpener())
}
