//
//  UploadImageView.swift
//  CityXcape
//
//  Created by James Allan on 9/27/24.
//

import SwiftUI

struct UploadImageView: View {
    @StateObject var vm: UploadViewModel
    @Binding var index: Int
    @State private var isDone: Bool = false
    
    var body: some View {
        VStack {
            OnboardingHeader()
            UploadImage()
            Spacer()
        }
        .background(SPBackground())
    }
    
    
    @ViewBuilder
    func UploadImage() -> some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    vm.showPicker.toggle()
                }, label: {
                    VStack {
                        SelfieBubble(size: 300, url: vm.imageUrl, pulse: 1)
                        Text(vm.username)
                            .foregroundStyle(.white)
                            .fontWeight(.thin)
                            .padding(.top, 10)
                    }
                })
                Spacer()
            }
            
            Spacer()
                .frame(height: 60)
            Text("Upload a Selfie")
                .font(.title3)
                .foregroundStyle(.white)
                .fontWeight(.light)
                .photosPicker(isPresented: $vm.showPicker, selection: $vm.selectedImage, matching: .images)
                
            
            Button(action: {
                vm.showPicker.toggle()
            }, label: {
                Text("Choose")
                    .frame(width: 150, height: 40)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .alert(isPresented: $vm.showError, content: {
                        Alert(title: Text(vm.errorMessage))
                    })
            })
            .padding(.top, 5)
            
            
            Button(action: {
              submitImage()
            }, label: {
                Label("Done", systemImage: "checkmark.shield.fill")
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .frame(width: 125, height: 35)
                    .background(vm.imageUrl == "" ? .gray : .green)
                    .animation(.easeIn, value: isDone)
                    .clipShape(Capsule())
            })
            .padding(.top, 45)
            
        }
    }
    
    
    fileprivate func submitImage() {
        if vm.imageUrl.isEmpty {
            vm.errorMessage = "Please upload a picture of yourself"
            vm.showError.toggle()
            return
        }
        withAnimation {
            index = 5
        }
    }
    
  
}

#Preview {
    Onboarding()
}
