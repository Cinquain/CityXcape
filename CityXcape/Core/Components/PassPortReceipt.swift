//
//  PassPortReceipt.swift
//  CityXcape
//
//  Created by James Allan on 9/2/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PassPortReceipt: View {
    
    var spot: Location
    @State private var message: String = ""
    @State private var showSeal: Bool = false
    var body: some View {
       
        ZStack {
            
            VStack {
                Headline()
                PostalStamp()
                officialSeal()
            }
            .cornerRadius(12)
        }
        .background(Background())

    }
    
    @ViewBuilder
    func Headline() -> some View {
        VStack {
            HStack {
                Image(systemName: "menucard.fill")
                    .foregroundColor(.white)
                    .font(.title)
                    .scaledToFit()

                
                Text("Saved to Your Passport")
                    .font(.title3)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .alert(isPresented: $showSeal, content: {
                        return Alert(title: Text(message))
                    })
                Spacer()
                
            }
            Divider()
                .frame(height: 0.5)
                .background(.white)
        }
        .background(Color.black.opacity(0.9))

    }
    
    @ViewBuilder
    func officialSeal() -> some View {
        HStack {
            Spacer()
            Button(action: {
                message = "Visited on \(Date().formattedDate())"
                showSeal.toggle()
            }, label: {
                Image("Certified")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .rotationEffect(Angle(degrees: -45))
            })
            
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func PostalStamp() -> some View {
        HStack {
            Button(action: {
                
            }, label: {
                VStack {
                    Image("postal")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(height: 200)
                        .overlay(
                            WebImage(url: URL(string: spot.imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 180, maxHeight: 180)
                                .clipped()
                        )
   
                    HStack(spacing: 0) {
                        Image("Pin")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor(.white)
                        
                        Text(spot.name)
                            .foregroundStyle(.white)
                            .fontWeight(.thin)
                            .font(.title3)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                    
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
    PassPortReceipt(spot: Location.demo)
}
