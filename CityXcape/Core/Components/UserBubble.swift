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
        ZStack(alignment: .center) {
            
            Circle()
                .fill(.orange.opacity(0.35))
                .frame(width: size)
                .shadow(color: .orange.opacity(0.35), radius: 10)
                .scaleEffect(self.animate ? 1.1 : 1)
                .animation(Animation.linear(duration: pulse).repeatForever(autoreverses: true), value: animate)
                .shadow(color: .orange.opacity(0.35), radius: 10)
            
            Circle()
                .fill(.orange.opacity(0.35))
                .frame(width: size * 0.85)
                .shadow(color: .orange.opacity(0.35), radius: 10)
                .scaleEffect(self.animate ? 1.10 : 1)
                .shadow(color: .orange.opacity(0.35), radius: 10)
                
            
            
            WebImage(url: URL(string: url))
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: size  * 0.75)
                .shadow(color: .gray, radius: 2)
            
            
        }
        .onAppear(perform: {
            self.animate.toggle()
        })
    }
}

#Preview {
    UserBubble(size: 300, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FEVTU961bfeCZBEBzrBL0%2FSandra.png?alt=media&token=07058b02-642b-44e4-a0ef-3548b250787e", pulse: 1.5)
}
