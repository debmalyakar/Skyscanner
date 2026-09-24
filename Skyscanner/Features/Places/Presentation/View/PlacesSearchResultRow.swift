//
//  PlacesSearchResultRow.swift
//  Skyscanner
//
//  Created by debmalyakar on 24/09/26.
//

import SwiftUI
// Search row view for places

struct PlacesSearchResultRow: View {
    let result: GeocodingResult
    let isSaved: Bool
    var onAdd: () -> Void

    private var subtitle: String {
        [result.admin1.flatMap { $0 == result.name ? nil : $0 }, result.country]
            .compactMap { $0 }
            .joined(separator: " · ")
    }

    var body: some View {
        Button(action: onAdd) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(result.name)
                        .font(.system(size: 17, weight: .semibold))
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.white.opacity(0.88))
                    }
                }
                Spacer()
                Image(systemName: isSaved ? "checkmark.circle.fill" : "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(isSaved ? Color.mint : Color.sun)
            }
            .padding(.horizontal, AppPadding.padding8)
            .frame(minHeight: 64)
            .glassCard()
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
        .disabled(isSaved)
    }
}

#Preview {
    PlacesSearchResultRow(result: GeocodingResult(id: 1, name: "test", latitude: 23.32, longitude: 33.33, country: "India", admin1: "", timezone: ""), isSaved: false, onAdd: {})
}
