//
//  AppFont.swift
//  Skyscanner
//
//  Created by debmalyakar on 20/09/26.
//
import SwiftUI
import Foundation

struct AppFontSystem : ViewModifier {
    let size: CGFloat
    let weight: Font.Weight
    let design: Font.Design
    
    func body(content : Content) -> some View {
        Text("")
            
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}

extension View {
    func systemLargeRoundedTitle() -> some View {
        modifier(AppFontSystem(size: 136, weight: .ultraLight, design: .rounded))
    }
    
    func systemMediumRoundedTitle() -> some View {
        modifier(AppFontSystem(size: 44, weight: .ultraLight, design: .rounded))
    }
}
