//
//  UserDot.swift
//  CityXcape
//
//  Created by James Allan on 8/1/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserDot: View {
    
    let size: CGFloat
    let url: String
    
    var body: some View {
        ZStack {
            Image("dot")
                .resizable()
                .scaledToFit()
                .frame(width: size)
            
            WebImage(url: URL(string: url))
                .resizable()
                .scaledToFit()
                .frame(width: size - (size * 1/3))
                .clipShape(Circle())
        }
    }
    
}

#Preview {

    UserDot(size: 250, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fman.png?alt=media&token=7b2a24de-49ce-4d40-a9a6-26325ee45371")
        .previewLayout(.sizeThatFits)
}
