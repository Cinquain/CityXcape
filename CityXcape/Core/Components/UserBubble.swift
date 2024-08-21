//
//  OrangeBubble.swift
//  CityXcape
//
//  Created by James Allan on 8/1/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserBubble: View {
    
    @State private var animate: Bool = false
    
    let size: CGFloat
    let url: String
    let pulse : Double
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(.orange.opacity(0.35))
                .frame(width: size)
                .shadow(color: .orange.opacity(0.35), radius: 10)
                .scaleEffect(self.animate ? 1.10 : 1)
                .animation(Animation.linear(duration: pulse).repeatForever(autoreverses: true), value: animate)
                .shadow(color: .orange.opacity(0.35), radius: 10)
            
            Circle()
                .fill(.orange.opacity(0.35))
                .frame(width: size - 30)
                .shadow(color: .orange.opacity(0.35), radius: 10)
                .scaleEffect(self.animate ? 1.10 : 1)
                .shadow(color: .orange.opacity(0.35), radius: 10)
            
            
            WebImage(url: URL(string: url))
                .resizable()
                .scaledToFit()
                .frame(width: size  * 5.5/7)
            
            
        }
        .onAppear(perform: {
            self.animate.toggle()
        })
    }
}

#Preview {
    UserBubble(size: 300, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fman.png?alt=media&token=7b2a24de-49ce-4d40-a9a6-26325ee45371", pulse: 1.5)
}
