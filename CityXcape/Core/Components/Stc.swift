//
//  STC.swift
//  CityXcape
//
//  Created by James Allan on 8/5/24.
//

import SwiftUI

struct Stc: View {
    
    @State private var animate: Bool = false
    @State private var rotation: Double = 0
    
    let size: CGFloat
    
    var body: some View {
        Image("StreetCred")
            .resizable()
            .scaledToFit()
            .frame(height: size)
            .rotationEffect(Angle(degrees: rotation))
            .animation(.easeInOut(duration: 1), value: animate)
            .onAppear(perform: {
                animate.toggle()
                rotation = 360
            })
    }
}

#Preview {
    Stc(size: 300)
        .previewLayout(.sizeThatFits)
}
