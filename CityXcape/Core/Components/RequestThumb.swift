//
//  RequestThumb.swift
//  CityXcape
//
//  Created by James Allan on 8/22/24.
//

import SwiftUI

struct RequestThumb: View {
    var body: some View {
        
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.black.opacity(0.6))
                .frame(width: 200, height: 280)
                .cornerRadius(12)
            
            Text("Hello handsome, want to buy me a drink")
                .font(.caption)
                .foregroundStyle(.black)
                .fontWeight(.thin)
                .lineLimit(1)
                .frame(width: 130, height: 20)
                .background(Color.gray.opacity(1))
                .clipShape(Capsule())
                .padding(.top, 10)
            VStack {
                Spacer()
                UserDot(size: 150, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c")
                Text("Kandi")
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .padding(.bottom, 10)
            }
        }
        .background(background())
        .frame(width: 200, height: 280)
        .cornerRadius(12)
        .clipped()

        
    }
    
    @ViewBuilder
    func background() -> some View {
        Image("hex-background")
            .resizable()
            .scaledToFill()
    }
}

#Preview {
    RequestThumb()
        .previewLayout(.sizeThatFits)
}
