//
//  CreateUsername.swift
//  CityXcape
//
//  Created by James Allan on 9/27/24.
//

import SwiftUI

struct CreateUsername: View {
    
    @StateObject var vm: UploadViewModel
    @Binding var index: Int
    @State var isDone : Bool = false
    
    var body: some View {
        VStack {
            header()
            Spacer()

            VStack {
                Image(systemName: "faceid")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
                Text("Digital Identity")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                
            }
            .padding(.bottom, 30)

            
            TextField(" Create a Username", text: $vm.username)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
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
                    .foregroundStyle(.orange)
                    .font(.callout)
                    .fontWeight(.light)
                HStack {
                    Spacer()
                    Toggle(vm.gender ? "Male" : "Female", isOn: $vm.gender)
                        .foregroundStyle(vm.gender ? .white : .pink)
                        .fontWeight(.regular)
                        .frame(width: 115)
                    Spacer()
                }
                
           
            }
            
            
            Button(action: {
              submitUsername()
            }, label: {
                Label("Done", systemImage: "checkmark.shield.fill")
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .frame(width: 125, height: 35)
                    .background(vm.username.count > 3 ? .green : .gray)
                    .animation(.easeIn, value: isDone)
                    .clipShape(Capsule())
            })
            .padding(.top, 45)
        
            
            Spacer()
        }
        .background(SPBackground())
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
        vm.submitNameGender()
        withAnimation {
            index = 2
        }
    }
    
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("")
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

