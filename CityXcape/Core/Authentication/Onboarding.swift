//
//  Onboarding.swift
//  CityXcape
//
//  Created by James Allan on 9/4/24.
//

import SwiftUI

struct Onboarding: View {
    @Environment(\.dismiss) var dismiss

    @State private var showPicker: Bool = false
    @State private var tabselection = 0
    @StateObject var vm = UploadViewModel()
    var body: some View {
        TabView(selection: $tabselection) {
            
            CreateUsername(vm: vm, selection: $tabselection)
                .tag(0)
            
            FindCityView(selection: $tabselection, vm: vm)
                .tag(1)
            
            UploadImageView(vm: vm, selection: $tabselection)
                .tag(2)
            
            ChooseWorldView(vm: vm, selection: $tabselection)
                .tag(3)
            
            StreetIDCard(vm: vm)
                .tag(4)
                
        }
        .tabViewStyle(.page)
        .edgesIgnoringSafeArea(.all)
    }
    
    
    @ViewBuilder
    func UploadImage() -> some View {
        VStack {
            header()
            HStack {
                Spacer()
                Button(action: {
                    showPicker.toggle()
                }, label: {
                    SelfieBubble(size: 300, url: vm.imageUrl, pulse: 1)
                })
                Spacer()
            }
            
            Spacer()
                .frame(height: 100)
            Text("Upload Selfie")
                .font(.title3)
                .foregroundStyle(.white)
                .fontWeight(.thin)
                .photosPicker(isPresented: $showPicker, selection: $vm.selectedImage, matching: .images)
                
            
            Button(action: {
                showPicker.toggle()
            }, label: {
                Text("Choose")
                    .frame(width: 150, height: 40)
                    .background(Color.white)
                    .clipShape(Capsule())
            })
            .padding(.top, 5)
            Spacer()
        }
        .background(background())
    }
    

    
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("colored-paths")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("STREETPASS")
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .tracking(4)
                    .opacity(0.7)
                Text("STC Balance: 0")
                    .font(.caption)
                    .fontWeight(.thin)
                    .opacity(0.7)
            }
            .foregroundStyle(.white)
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.uturn.down.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.5))
            })
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    Onboarding()
}
