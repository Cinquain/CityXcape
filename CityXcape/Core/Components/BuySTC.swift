//
//  BuySTC.swift
//  CityXcape
//
//  Created by James Allan on 8/14/24.
//

import SwiftUI

struct BuySTC: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var message: String = ""
    @State private var showError: Bool = false

    var body: some View {
        VStack {
            headline()
            
            buttonRow()
            Spacer()
        }
        .cornerRadius(24)
        .background(background())
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    func background() -> some View {
        GeometryReader {
            let size = $0.size
            Image("network")
                .resizable()
                .scaledToFill()
                .overlay(Color.black.opacity(0.8))
                .frame(width: size.width, height: size.height)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    @ViewBuilder
    func headline() -> some View {
        VStack(spacing: 5) {
            Button(action: {
                dismiss()
            }, label: {
                Image("StreetCred")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
            })
            
            HStack {
                Spacer()
                VStack {
                    Text("Get StreetCred")
                        .fontWeight(.semibold)
                    
                    Text("Balance: 0 STC")
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .font(.caption)
                }
                Spacer()
            }
        }
        .padding(.bottom, 25)
        .foregroundStyle(.white)
    }
    
    @ViewBuilder
    func buttonRow() -> some View {
        VStack(spacing: 15) {
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                CoinCapsule(count: 3, price: 9.99)
            })
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                CoinCapsule(count: 15, price: 29.99)
            })
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                CoinCapsule(count: 50, price: 49.99)
            })
        }
        .padding(.bottom, 40)
    }
    
    
}

#Preview {
    BuySTC()
}
