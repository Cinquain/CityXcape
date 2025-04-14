//
//  PassPortReceipt.swift
//  CityXcape
//
//  Created by James Allan on 9/2/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PassPortReceipt: View {
    var body: some View {
       
        ZStack {
            
            VStack {
                Headline()
                PostalStamp()
                Spacer()
            }
            .cornerRadius(12)
        }
        .background(Background())

    }
    
    @ViewBuilder
    func Headline() -> some View {
        VStack {
            HStack {
                Image("Pin")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                Text("Saved to Your Passport")
                    .font(.title3)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                Spacer()
                
            }
            Divider()
                .frame(height: 0.5)
                .background(.white)
        }
        .background(Color.black.opacity(0.9))

    }
    
    
    @ViewBuilder
    func PostalStamp() -> some View {
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
                            WebImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fmaxresdefault.jpg?alt=media&token=c29d351b-b204-426d-a7f2-e71cba4396d3"))
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
        .padding(.bottom, 10)
    }
    
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            Color.black
            Image("travel")
                .resizable()
                .scaledToFill()
                .opacity(0.6)
        }
    }
}

#Preview {
    PassPortReceipt()
}
