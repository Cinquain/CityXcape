//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/2/24.
//

import SwiftUI
import Shimmer
import SDWebImageSwiftUI

struct PublicStreetPass: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var message: String = ""
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var isShimmering: Bool = false
    @State private var buySTC: Bool = false
    
    var body: some View {
        VStack {
            header()
            userView()
            worldList()
            Spacer()
            ctaButton()
        }
        .background(background())
        .onAppear {
            isShimmering = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                withAnimation {
                    isShimmering = false
                }
            })
        }
      
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("orange-paths")
                .resizable()
                .scaledToFill()
                .rotationEffect(Angle(degrees: 180))
                .opacity(0.8)
                .shimmering(active: isShimmering, duration: 0.7, bounce: true)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Text("STREETPASS")
                .font(.system(size: 24))
                .fontWeight(.thin)
                .foregroundStyle(.white)
                .tracking(4)
                .padding(.top, 5)
            
            Spacer()
         
        }
        .padding(.horizontal, 22)
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
            Button(action: {
                buySTC.toggle()
            }, label: {
                Text("message")
                    .font(.title3)
                    .fontWeight(.thin)
                    .foregroundStyle(.black)
                    .frame(width: 200, height: 45)
                    .background(.orange)
                    .clipShape(Capsule())
            })
            .sheet(isPresented: $buySTC, content: {
                BuySTC()
                    .presentationDetents([.height(370)])
            })
    }
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            UserBubble(size: 300, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c", pulse: 1.3)
            
            Text("Allison")
                .font(.title)
                .foregroundStyle(.white)
                .fontWeight(.thin)
            
            
        
            
        }
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach([World.demo6, World.demo4, World.demo5]) { world in
                Button {
                    //
                } label: {
                    VStack {
                        WebImage(url: URL(string: world.imageUrl))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 65)
                        
                        Text(world.name)
                            .font(.callout)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .fontWeight(.thin)
                            .frame(width: 55)
                    }
                }

            }
        }
        .padding(.top, 10)
        
    }
    
}

#Preview {
    PublicStreetPass()
}
