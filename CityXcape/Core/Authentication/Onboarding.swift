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
