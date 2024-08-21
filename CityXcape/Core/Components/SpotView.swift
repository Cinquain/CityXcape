//
//  SpotView.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct SpotView: View {
    var body: some View {
        ZStack {
            WebImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fmaxresdefault.jpg?alt=media&token=c29d351b-b204-426d-a7f2-e71cba4396d3"))
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .overlay(content: overlay)
                .cornerRadius(15)
            
        }
    }
    
    @ViewBuilder
    func overlay() -> some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [.clear, .black],
                           startPoint: .center,
                           endPoint: .bottom)
            HStack {
                Image("Pin")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                
                Text("Graffiti Pier")
                    .fontWeight(.thin)
                    .font(.title3)
                
                Spacer()
                
                Image(systemName: "figure.walk.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.9)
                    .foregroundStyle(.white)
                    .frame(height: 30)
                
                Text("1.2 mile")
                    .font(.callout)
                    .fontWeight(.thin)
                
            
            }
            .foregroundStyle(.white)
            .padding(.bottom, 10)
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    SpotView()
}
