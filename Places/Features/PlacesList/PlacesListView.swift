//
//  PlacesListView.swift
//  Places
//

import SwiftUI

struct PlacesListView: View {
    private let dependencies: AppDependencies
    @StateObject private var viewModel: PlacesListViewModel
    @State private var isAddingPlace = false

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
        _viewModel = StateObject(wrappedValue: PlacesListViewModel(
            repository: dependencies.placesRepository,
            cache: dependencies.placesCache,
            urlOpener: dependencies.urlOpener
        ))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Places")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            isAddingPlace = true
                        } label: {
                            Label("Custom place", systemImage: "plus")
                        }
                    }
                }
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $isAddingPlace) {
            CustomPlaceView(urlOpener: dependencies.urlOpener, store: dependencies.lastCoordinateStore)
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

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
        case .loaded(let places) where places.isEmpty:
            EmptyStateView()
        case .loaded(let places):
            VStack(spacing: 0) {
                if viewModel.isShowingCachedPlaces {
                    CachedPlacesBanner()
                }
                List(places) { place in
                    Button {
                        Task { await viewModel.select(place) }
                    } label: {
                        PlaceRow(place: place)
                    }
                    .buttonStyle(.plain)
                }
                .refreshable { await viewModel.refresh() }
            }
        case .failed(let error):
            ErrorStateView(error: error) {
                Task { await viewModel.load() }
            }
        }
    }
}

#Preview {
    PlacesListView(dependencies: .preview())
}
