//
//  UploadImageView.swift
//  CityXcape
//
//  Created by James Allan on 9/27/24.
//

import SwiftUI

struct UploadImageView: View {
    @StateObject var vm: UploadViewModel
    @Binding var selection: Int
    
    @State private var showPicker: Bool = false
    
    var body: some View {
        VStack {
            header()
            UploadImage()
            Spacer()
        }
        .background(background())
    }
    
    
    @ViewBuilder
    func UploadImage() -> some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showPicker.toggle()
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
                .fontWeight(.thin)
                .photosPicker(isPresented: $showPicker, selection: $vm.selectedImage, matching: .images)
                
            
            Button(action: {
                showPicker.toggle()
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
                HStack(spacing: 2) {
                    
                    Image(systemName: "forward.fill")
                        .foregroundStyle(.white)
                        .font(.callout)
                }
                .frame(width: 55, height: 55)
                .background(.blue)
                .clipShape(Circle())
            })
            .padding(.top, 25)
        }
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
    
    fileprivate func submitImage() {
        if vm.imageUrl.isEmpty {
            vm.errorMessage = "Please upload a picture of yourself"
            vm.showError.toggle()
            return
        }
        withAnimation {
            selection = 3
        }
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(LocationService.shared.city)
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .tracking(4)
                
                Text("STREETPASS")
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .tracking(4)
                    .opacity(0.7)
               
            }
            .foregroundStyle(.white)
            
            Spacer()
        
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    Onboarding()
}
