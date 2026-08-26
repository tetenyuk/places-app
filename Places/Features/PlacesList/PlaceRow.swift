//
//  PlaceRow.swift
//  Places
//

import SwiftUI

struct PlaceRow: View {
    let place: Place

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(place.displayName)
            Text(place.coordinate.formatted)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    List {
        PlaceRow(place: Place(name: "Amsterdam", coordinate: Coordinate(latitude: 52.3547498, longitude: 4.8339215)!))
        PlaceRow(place: Place(name: nil, coordinate: Coordinate(latitude: 40.4380638, longitude: -3.7495758)!))
    }
}
