//
//  PlacesHeader.swift
//  Skyscanner
//
//  Created by debmalyakar on 22/09/26.
//

import SwiftUI

struct PlacesHeader: View {
    var heading : String
    var body: some View {
        HStack {
            Text(heading)
                .foregroundStyle(Color.white)
                .skyFont(.screenTitle)
                .frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .center))
            
            Button(action: {
                
            }, label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.ink)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.sun))
            })
        }
             
    }
}

#Preview {
    PlacesHeader(heading: "Places")
}
