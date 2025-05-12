//
//  StreetIDCard.swift
//  CityXcape
//
//  Created by James Allan on 10/1/24.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct StreetIDCard: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var vm: AuthViewModel
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            header()
            userView()
            
            worldList()
            Spacer()
            
    
            createSPButton()

        }
        .background(SPBackground())
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach(vm.selectedWorlds) {
                WebImage(url: URL(string: $0.imageUrl))
                    .resizable()
                    .scaledToFit()
                    .colorInvert()
                    .frame(height: 55)
            }
        }
        .padding(.top, 25)
        .alert(isPresented: $vm.showError) {
            return Alert(title: Text(vm.errorMessage))
        }
        
    }
    
    @ViewBuilder
    func header() -> some View {
        Spacer()
            .frame(height: 100)
        HStack {
            Spacer()
            Text("Welcome to CityXcape")
                .foregroundStyle(.white)
                .fontWeight(.thin)
                .font(.title2)
            Spacer()
        }

    }
    
    @ViewBuilder
    func createSPButton() -> some View {
        VStack {
            agreeToTerms()
            
            Button {
                guard vm.checkAllFields() else {return}
                dismiss()
            } label: {
                Text("Create Account")
                    .fontWeight(.thin)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 40)
                    .background(.blue)
                    .clipShape(Capsule())
                    .photosPicker(isPresented: $vm.showPicker, selection: $vm.selectedImage, matching: .images)
            }
        }

    }
    
    @ViewBuilder
    func agreeToTerms() -> some View {
        HStack {
            
            Image(systemName: vm.isChecked ? "checkmark.square.fill" : "square")
                .foregroundStyle(.white)
                .onTapGesture {
                    vm.isChecked.toggle()
                }
            

            Text("I agree to [terms and conditions](https://cityxcape.com/terms)")
                .fontWeight(.thin)
                .foregroundStyle(.white)
                    

        }
        .padding(.bottom, 20)
        
    }
  
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            Button(action: {
                vm.showPicker.toggle()
            }, label: {
                    SelfieBubble(
                        size: 300,
                        url: vm.imageUrl,
                    pulse: 1.2)
            })
                    
            VStack {
                Text(vm.username)
                    .font(.title2)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                
                Text("3 StreetCred")
                    .fontWeight(.thin)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding(.top, 10)
            }
          
        }
    }
    
    func openCustom(url: String) {
        guard let url = URL(string: url) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }


}

#Preview {
    StreetIDCard(vm: AuthViewModel())
}
