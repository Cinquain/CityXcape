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
        if match {
            withAnimation {
                MatchAnimation()
            }
        } else {
            VStack(spacing: 20) {
                userBubble()
                
                messageBubble()
                
                TimerView(size: 150, thickness: 20, font: .title2)
                    .padding(.top, 15)
                ctaButton()
                Spacer()
                dismissButton()
                
            }
            .background(background())
        }
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
    
    @ViewBuilder
    func dismissButton() -> some View {
        Button(action: {
            dismiss()
        }, label: {
            Image("down-arrow")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
        })
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
        Button(action: {
            match.toggle()
        }, label: {
            Text("CONNECT")
                .font(.caption)
                .foregroundStyle(.black)
                .fontWeight(.light)
                .tracking(2)
                .frame(width: 140, height: 40)
                .background(.orange)
                .clipShape(Capsule())

        })
    }
    
    
}

#Preview {
    Cardview(request: Request.demo)
}
