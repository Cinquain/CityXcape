//
//  RequestView.swift
//  CityXcape
//
//  Created by James Allan on 8/15/24.
//

import SwiftUI

struct Cardview: View {
    
    let request: Request
    
    @State private var showSP: Bool = false
    var body: some View {
        VStack(spacing: 40) {
            userBubble()
            
            messageBubble()
            
            TimerView(size: 150, thickness: 20, font: .title2)
            Spacer()
        }
        .background(background())
    }
    
    @ViewBuilder
    func userBubble() -> some View {
        VStack(spacing: 8) {
            Button(action: {
                showSP.toggle()
            }, label: {
                UserBubble(size: 300, url: request.imageUrl, pulse: 2)
            })
            .sheet(isPresented: $showSP, content: {
                PublicStreetPass()
            })
            
            Text(request.username)
                    .font(.title2)
                .fontWeight(.thin)
        }
        .padding(.top, 40)
        .foregroundStyle(.white)
    }
    
    @ViewBuilder
    func messageBubble() -> some View {
        HStack {
            Spacer()
            Text(request.content)
                .font(.callout)
                .foregroundStyle(.white)
                .padding()
                .background(.black.opacity(0.8))
                .fontWeight(.light)
                .clipShape(Capsule())
            Spacer()
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            
            Image("honeycomb-black")
                .resizable()
                .scaledToFill()
                .opacity(0.5)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
  
    
    
}

#Preview {
    Cardview(request: Request.demo)
}
