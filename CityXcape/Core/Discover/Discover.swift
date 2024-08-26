//
//  Discover.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import SwiftUI

struct Discover: View {
    @State private var showPage: Bool = false
    var body: some View {
        VStack {
            headerView()
            Spacer()
            Image("glass")
                .resizable()
                .scaledToFit()
                .frame(height: 350)
                .overlay(content: qrCode)
                
            Text("Scan QR code to check in")
                .font(.title3)
                .foregroundStyle(.white)
                .fontWeight(.thin)
            ctaButton()
            Spacer()
        }
        .background(background())
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("black-paths")
                .renderingMode(.template)
                .foregroundStyle(.red)
                .scaledToFill()
              
        }
    }
    
    @ViewBuilder
    func qrCode() -> some View {
        Image("QR Code")
            .resizable()
            .scaledToFit()
            .frame(height: 150)
            .opacity(0.5)
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
        Button(action: {
            showPage.toggle()
        }, label: {
            Text("scan")
                .font(.title3)
                .foregroundStyle(.black)
                .fontWeight(.thin)
                .frame(width: 200, height: 40)
                .background(.orange)
                .clipShape(Capsule())
        })
        .fullScreenCover(isPresented: $showPage, content: {
            LocationView()
        })
    }
    
    @ViewBuilder
        func headerView() -> some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2) {
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                    Spacer()
                    
                   
                }
                .padding(.bottom, 4)
                
                Divider()
                    .background(.white)
                    .frame(height: 0.5)
            }
            .padding(.horizontal, 10)
        }
}

#Preview {
    Discover()
}
