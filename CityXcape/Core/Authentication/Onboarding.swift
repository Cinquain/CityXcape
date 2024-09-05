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
    @State private var tabselection = 1
    @State private var username: String = ""
    @StateObject var vm = UploadViewModel()
    var body: some View {
        TabView {
            
           UploadImage()
                .tag(1)
            
            CreateUsername()
            .tag(2)
                
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
            })
            .padding(.top, 5)
            Spacer()
        }
        .background(background())
    }
    
    @ViewBuilder
    func CreateUsername() -> some View {
        VStack {
            header()
            
            SelfieBubble(size: 300, url: vm.imageUrl, pulse: 1)
            
            Spacer()
                .frame(height: 40)
            
            TextField("  Create a Username", text: $username)
                .frame(width: 240, height: 40)
                .background(.white)
                .clipShape(Capsule())
                .alert(isPresented: $vm.showError, content: {
                    Alert(title: Text(vm.errorMessage))
                })
            
            HStack {
                Spacer()
                Toggle(vm.gender ? "Male" : "Female", isOn: $vm.gender)
                    .foregroundStyle(vm.gender ? .white : .pink)
                    .fontWeight(.regular)
                    .frame(width: 120)
                Spacer()
            }
            
            
            Button(action: {
                Task {
                    do {
                        try await vm.submitStreetPass()
                        vm.errorMessage = "StreetPass Created"
                        vm.showError.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            UserDefaults.standard.set(true, forKey: CXUserDefaults.createdSP)
                            dismiss()
                        })
                    } catch {
                        vm.errorMessage = error.localizedDescription
                        vm.showError.toggle()
                    }
                }
            }, label: {
                Text("Submit")
                    .frame(width: 150, height: 40)
                    .foregroundStyle(.blue)
                    .background(.white)
                    .clipShape(Capsule())
                    .padding(.top, 20)
            })
            
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
