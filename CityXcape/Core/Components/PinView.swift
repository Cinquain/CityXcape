//
//  PinView.swift
//  CityXcape
//
//  Created by James Allan on 8/1/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PinView: View {
    let height: CGFloat
    let url: String
    var body: some View {
        ZStack {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: height)
            
            
            WebImage(url: URL(string: url))
                .resizable()
                .scaledToFit()
                .frame(height: height / 1.39)
                .clipShape(Circle())
                .offset(y: -(height/15))
        }
    }
}

#Preview {
    PinView(height: 200, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fmaxresdefault.jpg?alt=media&token=c29d351b-b204-426d-a7f2-e71cba4396d3")
}
