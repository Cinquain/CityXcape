//
//  StreetPassBackground.swift
//  CityXcape
//
//  Created by James Allan on 11/6/24.
//

import SwiftUI

struct SPBackground: View {
    var body: some View {
        ZStack {
            Color.black
            Image("colored-paths")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SPBackground()
}
