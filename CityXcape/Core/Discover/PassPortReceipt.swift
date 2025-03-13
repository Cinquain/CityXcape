//
//  PassPortReceipt.swift
//  CityXcape
//
//  Created by James Allan on 9/2/24.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct PassPortReceipt: View {
    
    var spot: Location
    @StateObject var vm: LocationViewModel
    
    @State private var message: String = ""
    @State private var showSeal: Bool = false
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
                Image(systemName: "menucard.fill")
                    .foregroundColor(.white)
                    .font(.title)
                    .scaledToFit()
                    .photosPicker(isPresented: $vm.showPicker, selection: $vm.selectedImage, matching: .images)

                
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
    func PostalStamp() -> some View {
        HStack {
            VStack {
                Image("postal")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(height: 200)
                    .overlay(
                        WebImage(url: URL(string: vm.stampImageUrl))
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
                        .sheet(isPresented: $vm.buySTC, content: {
                            BuySTC(usecase: .customStamp, vm: vm)
                                .presentationDetents([.height(370)])
                        })

                    
                    Text(spot.name)
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .font(.title3)
                        .lineLimit(1)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
                
                customizeStamp()
                
            }
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
    
    @ViewBuilder
    func customizeStamp() -> some View {
            Button {
                vm.checkStreetCredforStamp()
            } label: {
                HStack(spacing: 2) {
                    Image(systemName: "camera.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.black)
                    
                    Text("Customize Stamp")
                        .font(.callout)
                        .foregroundStyle(.black)
                        .fontWeight(.thin)
                }
                .frame(width: 200, height: 40)
                .background(.white)
                .clipShape(Capsule())
            }
    

    }
}

#Preview {
    PassPortReceipt(spot: Location.demo, vm: LocationViewModel())
}
