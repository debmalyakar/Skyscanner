//
//  File.swift
//  Skyscanner
//
//  Created by debmalyakar on 21/09/26.
//

import Foundation
import SwiftUI

 extension View {
    /// White 10% fill, white 16% hairline, 22pt continuous corners.
    func glassCard() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white.opacity(0.10))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.16), lineWidth: 1)
            )
    }
}

 extension View {
    /// A List row with no chrome, so the cards look the same as in the design.
    func plainRow(vertical: CGFloat = 5 , horizontal : CGFloat = 20) -> some View {
        self
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal))
    }
}
