//
//  PostalStamp.swift
//  CityXcape
//
//  Created by James Allan on 8/3/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostalStamp: View {
    let stamp: Stamp
    
    var body: some View {
        ZStack {
            Image("postal")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 155, height: 155)
            
            WebImage(url: URL(string: stamp.imageUrl))
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
            
            Text(stamp.spotName)
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
    PostalStamp(stamp: Stamp.demo)
}
