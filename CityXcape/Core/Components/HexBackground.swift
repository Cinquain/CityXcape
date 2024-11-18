//
//  HexBackground.swift
//  CityXcape
//
//  Created by James Allan on 11/16/24.
//

import SwiftUI

struct HexBackground: View {
    var body: some View {
   
            ZStack {
                Color.black
                Image("hex-background")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
                  
            }
            .edgesIgnoringSafeArea(.all)

        
    }
}

#Preview {
    HexBackground()
}
