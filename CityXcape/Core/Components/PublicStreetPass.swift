//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/2/24.
//

import SwiftUI
import Shimmer

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
            Spacer()
            buttonRow()
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
    func buttonRow() -> some View {
        HStack {
          
            
            CircleButton(perform: {
                buySTC.toggle()
            }, systemName: "message.fill", activeTint: .pink, inactiveTint: .orange.opacity(0.8))
            .popover(isPresented: $buySTC, content: {
                BuySTC()
                    .presentationDetents([.height(370)])
            })
            
            CircleButton(perform: {
                //TBD
            }, systemName: "info.circle.fill", activeTint: .cyan, inactiveTint: .orange.opacity(0.8))
            
            CircleButton(perform: {
                dismiss()
            }, systemName: "arrow.uturn.down.circle.fill", activeTint: .yellow, inactiveTint: .orange.opacity(0.8))
        }
        .padding(.bottom, 30)
    }
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            UserBubble(size: 300, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c", pulse: 1.3)
            
            Text("Allison")
                .font(.title)
                .foregroundStyle(.white)
                .fontWeight(.thin)
            
            
            HStack(spacing: 2) {
                Text("Queen")
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                    .font(.callout)
                Image(systemName: "crown.fill")
                    .foregroundColor(.white)
                    .font(.callout)
            }
            
        }
    }
}

#Preview {
    PublicStreetPass()
}
