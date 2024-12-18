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
            
            AuthPage(vm: vm, selection: $tabselection)
                .tag(0)
            
            CreateUsername(vm: vm, selection: $tabselection)
                .tag(1)
            
            FindCityView(selection: $tabselection, vm: vm)
                .tag(2)
            
            UploadImageView(vm: vm, selection: $tabselection)
                .tag(3)
            
            ChooseWorldView(vm: vm, selection: $tabselection)
                .tag(4)
            
            StreetIDCard(vm: vm)
                .tag(5)
                
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
