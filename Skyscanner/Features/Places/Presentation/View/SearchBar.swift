//
//  SearchBar.swift
//  Skyscanner
//
//  Created by debmalyakar on 21/09/26.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var query: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15))
                .foregroundStyle(Color.white.opacity(0.88))
            
            TextField("Search", text: $query , prompt: Text("Search city or postcode").foregroundColor(Color.white.opacity(0.72)))
                .foregroundStyle(Color.white.opacity(0.72))
                .frame(height: 48)
                .font(.system(size: 16))
                .submitLabel(.search)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
            
            if !query.isEmpty {
                Button(action : {
                    query = ""
                } , label : {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.white.opacity(0.72))
                })
                .buttonStyle(.plain)
            }
                
        }
        .padding(.horizontal, AppPadding.padding16)
        .frame(height: 48)
        .background(Capsule().fill(Color.white.opacity(0.10)))
        .overlay(Capsule().strokeBorder(Color.white.opacity(0.16), lineWidth: 1))
        .background(content: {
            Color.midnight
        })
    }
}

#Preview {
    @Previewable @State var str: String = ""
    SearchBar(query: $str)
}
