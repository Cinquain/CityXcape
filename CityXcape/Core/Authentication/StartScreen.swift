//
//  StartScreen.swift
//  CityXcape
//
//  Created by James Allan on 8/5/24.
//

import SwiftUI

struct StartScreen: View {
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Spacer()
            header()
            Spacer()
            ctaButton()
        }
        .background(background())
    }
    
    @ViewBuilder
    func header() -> some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(width: 250)
        
        HStack {
            Spacer()
            Text("Check in to Socialize")
                .font(.title3)
                .fontWeight(.thin)
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.bottom, 40)
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
        Button(action: {
            UserDefaults.standard.setValue(true, forKey: CXUserDefaults.firstOpen)
            dismiss()
        }, label: {
            Label("Find Location", systemImage: "location")
                .foregroundColor(.black)
                .fontWeight(.light)
                .frame(width: 250, height: 40)
                .background(.orange)
                .clipShape(Capsule())
        })
        .padding(.bottom, 10)
    }
    
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("hex-background")
                .opacity(0.6)
        }
    }
}

#Preview {
    StartScreen()
}
