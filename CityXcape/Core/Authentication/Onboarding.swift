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
    @State private var index = 0
    @StateObject var vm = UploadViewModel()
    var body: some View {
        TabView(selection: $index) {
            
            AuthPage(vm: vm, index: $index)
                .tag(0)
            
            CreateUsername(vm: vm, index: $index)
                .tag(1)
            
            NotificationView(vm: vm, index: $index)
                .tag(2)
            
            FindCityView(index: $index, vm: vm)
                .tag(3)
            
            UploadImageView(vm: vm, index: $index)
                .tag(4)
            
            ChooseWorldView(vm: vm, index: $index)
                .tag(5)
            
            StreetIDCard(vm: vm)
                .tag(6)
                
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
            Analytic.shared.startedOnboarding()
        })
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
