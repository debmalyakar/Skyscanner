//
//  File.swift
//  Skyscanner
//
//  Created by debmalyakar on 21/09/26.
//

import Foundation
import SwiftUI

private extension View {
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
