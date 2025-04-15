//
//  MatchAnimation.swift
//  CityXcape
//
//  Created by James Allan on 8/17/24.
//

import SwiftUI

struct MatchAnimation: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(CXUserDefaults.profileUrl) var profileUrl: String?

    @State var vm: ConnectionsVM
    
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
                
            UserBubble(size: 125, url: profileUrl ?? "", pulse: 2)
                .rotationEffect(Angle(degrees: rotation))
                .animation(.easeOut(duration: 0.5), value: rotation)
            
            Divider()
                .frame(width: length, height: 0)
                .background(.orange)
                .animation(.easeOut(duration: 0.5), value: length)

            UserBubble(size: 125, url: vm.requestImage, pulse: 2)
                .rotationEffect(Angle(degrees: rotation))
                .animation(.easeOut(duration: 0.5), value: rotation)

        }
        .padding(.horizontal, 10)
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
                withAnimation {
                    dismiss()
                    vm.showMessage = true
                    vm.showMatch = false
                }
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
    MatchAnimation(vm: ConnectionsVM())
}
