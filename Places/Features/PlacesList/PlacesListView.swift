//
//  PlacesListView.swift
//  Places
//

import SwiftUI

struct PlacesListView: View {
    @StateObject private var viewModel: PlacesListViewModel

    init(repository: any PlacesRepository) {
        _viewModel = StateObject(wrappedValue: PlacesListViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Places")
        }
        .task { await viewModel.load() }
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
                PlaceRow(place: place)
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
    PlacesListView(repository: StaticPlacesRepository())
}
