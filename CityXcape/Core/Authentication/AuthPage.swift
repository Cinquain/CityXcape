//
//  AuthPage.swift
//  CityXcape
//
//  Created by James Allan on 11/7/24.
//

import SwiftUI

struct AuthPage: View {
    @Environment(\.dismiss) var dismiss
    @Binding var index: Int

    @State var isAuth: Bool = false {
        didSet {
            isDone = true
        }
    }
    @State private var isDone: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            header()
            Spacer()
                .frame(height: 200)
            VStack {
                Image("dot person")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                  
                HStack {
                    Spacer()
                    Text("Create an Account")
                        .fontWeight(.light)
                        .font(.title2)
                        .alert(isPresented: $showError, content: {
                            return Alert(title: Text(errorMessage))
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
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title)
                        .foregroundStyle(.gray)
                }

                
            }
            .padding(.horizontal, 20)
        
    }
    
    fileprivate func checkAuth() {
        if AuthService.shared.uid == nil {
            errorMessage = "Please sign up using Apple or Google"
            showError.toggle()
            return
        }
        withAnimation {
            index = 1
        }
    }
}

#Preview {
    Onboarding()
}
