//
//  BlueBubble.swift
//  CityXcape
//
//  Created by James Allan on 8/1/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct SelfieBubble: View {
    @State private var animate: Bool = false
    
    let size: CGFloat
    let url: String
    let pulse : Double
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(.blue.opacity(0.35))
                .frame(width: size)
                .shadow(color: .blue.opacity(0.35), radius: 10)
                .scaleEffect(self.animate ? 1.10 : 1)
                .animation(Animation.linear(duration: pulse).repeatForever(autoreverses: true), value: animate)
                .shadow(color: .blue.opacity(0.35), radius: 10)
            
            Circle()
                .fill(.blue.opacity(0.35))
                .frame(width: size - 30)
                .shadow(color: .blue.opacity(0.35), radius: 10)
                .scaleEffect(self.animate ? 1.10 : 1)
                .shadow(color: .blue.opacity(0.35), radius: 10)
            
            
            WebImage(url: URL(string: url))
                .resizable()
                .scaledToFit()
                .frame(width: size  * 5.5/7)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 2)

            
            
        }
        .onAppear(perform: {
            self.animate.toggle()
        })
    }
}

#Preview {
    SelfieBubble(size: 300, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FCiara%20copy.png?alt=media&token=1a10681a-139a-4be7-9ab5-a71ef907bf10", pulse: 5.0)
}
