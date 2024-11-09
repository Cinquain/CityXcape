//
//  AuthPage.swift
//  CityXcape
//
//  Created by James Allan on 11/7/24.
//

import SwiftUI

struct AuthPage: View {
    @Environment(\.dismiss) var dismiss

    @State var isAuth: Bool = false {
        didSet {
            isDone = true
        }
    }
    @State private var isDone: Bool = false
    @StateObject var vm: UploadViewModel
    @Binding var selection: Int
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    var body: some View {
        VStack {
            OnboardingHeader()
            Spacer()
                .frame(height: 200)
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .scaledToFit()
                    .font(.system(size: 100))
                HStack {
                    Spacer()
                    Text("Let's Create Your Login")
                        .fontWeight(.light)
                        .font(.title2)
                        .alert(isPresented: $vm.showError, content: {
                            return Alert(title: Text(vm.errorMessage))
                        })
                    
                    Spacer()
                }
            }
            .foregroundColor(.white)
            
            
            Button {
                AuthService.shared.startSignInWithAppleFlow(view: self)
            } label: {
                Label("Sign up with Apple", systemImage: "applelogo")
                    .foregroundStyle(.white)
                    .frame(width: 220, height: 45)
                    .background(.black)
                    .clipShape(Capsule())
            }
            .padding(.top, 30)

            
            Button {
                Task {
                    do {
                        let result = try await AuthService.shared.startSigninWithGoogle(signUpview: self)
                    } catch {
                        errorMessage = error.localizedDescription
                        showError.toggle()
                    }
                }
            } label: {
                HStack {
                    Image("Google-Symbol")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                    
                    Text("Sign up with Google")
                    
                }
                .foregroundStyle(.white)
                .frame(width: 220, height: 45)
                .background(.black)
                .clipShape(Capsule())
            }
            
            
            Button(action: {
                checkAuth()
            }, label: {
                
                Label("Done", systemImage: "checkmark.shield.fill")
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .frame(width: 125, height: 35)
                    .background(isDone ? .green : .gray)
                    .animation(.easeIn, value: isDone)
                    .clipShape(Capsule())
                
               
            })
            .padding(.top, 45)


            Spacer()
        }
        .background(SPBackground())
    }
    
    fileprivate func checkAuth() {
        if AuthService.shared.uid == nil {
            vm.errorMessage = "Please sign up using Apple or Google"
            vm.showError.toggle()
            return
        }
        isDone = true
        withAnimation {
            selection = 1
        }
    }
}

#Preview {
    Onboarding()
}
