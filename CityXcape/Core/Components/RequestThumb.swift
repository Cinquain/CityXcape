//
//  RequestThumb.swift
//  CityXcape
//
//  Created by James Allan on 11/18/24.
//

import SwiftUI

struct RequestThumb: View {
    var request: Request
    var body: some View {
        HStack {
            VStack {
                UserBubble(size: 120, url: request.imageUrl, pulse: 2)
                Text(request.username)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
            }
            
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Text(request.content)
                            .foregroundStyle(.black)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding()
                    .background(.orange.opacity(0.8))
                    .cornerRadius(8)
                }
                HStack(spacing: 2) {
                    Image("dot person")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .padding(.leading, 10)

                    
                    Text("\(request.spotName)")
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .lineLimit(1)
                    Spacer()
                    
                }
            }
            .padding(.horizontal, 5)
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.top, 10)
        .background(.black)
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("grid")
                .resizable()
            .scaledToFit()
            .opacity(0.7)
        }
    }
    
}

#Preview {
    RequestThumb(request: Request.demo2)
}
