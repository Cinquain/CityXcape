//
//  PostalStamp.swift
//  CityXcape
//
//  Created by James Allan on 8/3/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostalStamp: View {
    let url: String
    
    var body: some View {
        ZStack {
            Image("postal")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 155, height: 155)
            
            WebImage(url: URL(string: url))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 155 - 20, maxHeight: 155 - 20)
                .clipped()
                .overlay(title(), alignment: .bottom)
            
        }
    }
    
    
    @ViewBuilder
    func title() -> some View {
        HStack(spacing: 2) {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            
            Text("Graffiti Pier")
                .foregroundStyle(.white)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
            Spacer()
        }
        .padding(.bottom, 5)
        .padding(.horizontal, 10)
    }
}

#Preview {
    PostalStamp(url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fmaxresdefault.jpg?alt=media&token=c29d351b-b204-426d-a7f2-e71cba4396d3")
}
