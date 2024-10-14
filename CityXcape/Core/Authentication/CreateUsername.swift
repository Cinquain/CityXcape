//
//  CreateUsername.swift
//  CityXcape
//
//  Created by James Allan on 9/27/24.
//

import SwiftUI

struct CreateUsername: View {
    
    @StateObject var vm: UploadViewModel
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            header()
            
            Spacer()

            VStack {
                Image(systemName: "info.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                Text("Tell Us About You")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                
            }
            .padding(.bottom, 30)

            
            TextField(" Create a Username", text: $vm.username)
                .frame(width: 260, height: 40)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(Capsule())
                .alert(isPresented: $vm.showError, content: {
                    Alert(title: Text(vm.errorMessage))
                })
                .padding(.bottom, 10)
            
            VStack {
                Text("Set Your Gender")
                    .foregroundStyle(.white)
                    .font(.callout)
                    .fontWeight(.thin)
                HStack {
                    Spacer()
                    Toggle(vm.gender ? "Male" : "Female", isOn: $vm.gender)
                        .foregroundStyle(vm.gender ? .white : .pink)
                        .fontWeight(.regular)
                        .frame(width: 115)
                    Spacer()
                }
                
                Picker("Sexual Orientation", selection: $vm.orientation) {
                    ForEach(Orientation.allCases) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.top, 20)
                .foregroundStyle(.red)
            }
            
            
            Button(action: {
              submitUsername()
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
            .padding(.top, 45)
        
            
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
                    .font(.system(size: 28))
                    .fontWeight(.thin)
                    .tracking(4)
                    .opacity(0.7)
            }
            .foregroundStyle(.white)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    fileprivate func submitUsername() {
        if vm.username.isEmpty {
            vm.errorMessage = "Please create a username and select your gender"
            vm.showError.toggle()
            return
        }
        if vm.username.count < 3 {
            vm.errorMessage = "Please create a username"
            vm.showError.toggle()
            return
        }
        withAnimation {
            selection = 1
        }
    }
}

#Preview {
    Onboarding()
}

