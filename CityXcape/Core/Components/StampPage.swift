//
//  StampPage.swift
//  CityXcape
//
//  Created by James Allan on 9/2/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct StampPage: View {
    
    var stamp: Stamp
    
    var body: some View {
        VStack {
            postalStamp()
            title()
            passportSeal()
        }
        .background(background())
        .cornerRadius(10)
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func passportSeal() -> some View {
        HStack {
            Spacer()
            StampView(name: stamp.spotName, date: stamp.timestamp)
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func postalStamp() -> some View {
        HStack {
            Button(action: {
                
            }, label: {
                ZStack {
                    Image("postal")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(height: 200)
                        .overlay(
                            WebImage(url: URL(string: stamp.imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 180, maxHeight: 180)
                                .clipped()
                        )
                }
            })
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func title() -> some View {
        HStack {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
            
            Text(stamp.spotName)
                .font(.title3)
                .fontWeight(.regular)
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("travel")
                .resizable()
                .scaledToFill()
                .opacity(0.6)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    StampPage(stamp: Stamp.demo)
}
