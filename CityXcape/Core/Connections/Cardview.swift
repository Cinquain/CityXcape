//
//  RequestView.swift
//  CityXcape
//
//  Created by James Allan on 8/15/24.
//

import SwiftUI

struct Cardview: View {
    @Environment(\.dismiss) private var dismiss
    let request: Request
    
    @State private var match: Bool = false
    @State private var showSP: Bool = false
    var body: some View {
        ZStack {
            if match {
                withAnimation {
                    MatchAnimation()
                }
            } else {
                VStack(spacing: 20) {
                    userBubble()
                    
                    messageBubble()
                    
                    TimerView(size: 100, thickness: 10, font: .title2)
                        .padding(.top, 15)
                    ctaButton()
                    Spacer()
                    
                }
                .background(background())
            }
        }
        .frame(width: 370, height: 600)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
           .stroke(.gray.opacity(0.7), lineWidth: 2)
              )
        .cornerRadius(12)
    }
    
    @ViewBuilder
    func userBubble() -> some View {
        VStack(spacing: 8) {
            Button(action: {
                showSP.toggle()
            }, label: {
                SelfieBubble(size: 250, url: request.imageUrl, pulse: 2)
            })
            .sheet(isPresented: $showSP, content: {
                PublicStreetPass(user: User.demo)
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
            
           Image("honeycomb-blue")
                .resizable()
                .foregroundColor(.orange)
                .opacity(0.3)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
   
    
    @ViewBuilder
    func ctaButton() -> some View {
        HStack {
        
            Button(action: {}, label: {
                Label("Pass", systemImage: "hand.raised.slash.fill")
                    .foregroundStyle(.red)
            })

            Spacer()

            Button(action: {
                match.toggle()
            }, label: {
                Label("Connect", systemImage: "powerplug.fill")
                    .foregroundColor(.green)
            })
            
        }
        .padding(.horizontal, 10)
    }
    
    
}

#Preview {
    Cardview(request: Request.demo)
        .previewLayout(.sizeThatFits)
}
