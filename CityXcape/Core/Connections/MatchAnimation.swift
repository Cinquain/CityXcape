//
//  MatchAnimation.swift
//  CityXcape
//
//  Created by James Allan on 8/17/24.
//

import SwiftUI

struct MatchAnimation: View {
    @Environment(\.dismiss) private var dismiss

    @State private var length: CGFloat = 120
    @State private var rotation: Double = 90
    @State private var opacity: Double = 0
    @State private var animate: Bool = false
    
    var body: some View {
        ZStack {
            AnimationView()
            VStack {
                Spacer()
                rotatingUsers()
                connectDot()
                Spacer()
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            rotation = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                withAnimation {
                    length = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    opacity = 1
                })
            })
        })
    }
    
    @ViewBuilder
    func rotatingUsers() -> some View {
        HStack {
                
            UserBubble(size: 125, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fman.png?alt=media&token=7b2a24de-49ce-4d40-a9a6-26325ee45371", pulse: 2)
                .rotationEffect(Angle(degrees: rotation))
                .animation(.easeOut(duration: 0.5), value: rotation)
            
            Divider()
                .frame(width: length, height: 0)
                .background(.orange)
                .animation(.easeOut(duration: 0.5), value: length)

            UserBubble(size: 125, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c", pulse: 2)
                .rotationEffect(Angle(degrees: rotation))
                .animation(.easeOut(duration: 0.5), value: rotation)

        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func connectDot() -> some View {
        VStack {
            Image("honeycomb")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
            
            Text("New Connection")
                .foregroundStyle(.orange)
                .fontWeight(.thin)
                .font(.title2)
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Start Chatting")
                    .font(.callout)
                    .fontWeight(.thin)
                    .foregroundStyle(.black)
                    .frame(width: 150, height: 40)
                    .background(.orange)
                    .clipShape(Capsule())
            })
        }
        .opacity(opacity)
        .animation(.easeInOut(duration: 0.5), value: opacity)
    }
    
}

#Preview {
    MatchAnimation()
}
