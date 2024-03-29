//
//  SignUpView.swift
//  CityXcape
//
//  Created by James Allan on 8/17/23.
//

import SwiftUI
import AsyncButton

struct SignUpView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var isAuth: Bool
    @Binding var userExist: Bool 
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @EnvironmentObject private var spM: StreetPassViewModel

    
    var body: some View {
        GeometryReader {
            let size = $0.size
           
                VStack {
                    Spacer()
                    HeaderView()
                    SignInButtons()
    
                    Spacer()
                    Spacer()
                    DismissButton()
                    Spacer()
                    
                }
                .frame(width: size.width, height: size.height)
                .edgesIgnoringSafeArea(.bottom)
            
              
        }
        .background(Color.black)
       
    }
   

    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            Image("Broken Pin")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .clipShape(Circle())
                .shadow(color: .orange, radius:10)
              
                
            Text("SIGN IN WITH")
                .foregroundColor(.white)
                .fontWeight(.thin)
                .padding(.top, 8)
                .tracking(5)
        }
    }
    
    @ViewBuilder
    func SignInButtons() -> some View {
        HStack {
            Button {
                Task {
                    do {
                        let result = try await AuthService.shared.startSignInWithGoogleFlow()
                        isAuth = true
                        dismiss()
                    } catch {
                        errorMessage = error.localizedDescription
                        showError.toggle()
                    }
                }
                 
            } label: {
                Image("Google-Symbol")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                   
            }
            
            Button {
                    AuthService.shared.startSignInWithAppleFlow(view: self)
                    isAuth = true
                    
            } label: {
                Image("apple-emblem")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 78, height: 78)
                    .clipShape(Circle())
                   
            }
        }
    }
    
    @ViewBuilder
    func DismissButton() -> some View {
        Button {
            dismiss()
        } label: {
            Text("DISMISS")
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.black)
                .background(Capsule().fill(.gray.opacity(0.8)).frame(width: 120, height: 40))
                .padding(.top, 75)
        }
    }
   
}

struct SignUpView_Previews: PreviewProvider {
    @State static var auth: Bool = false
    @State static var exist: Bool = false

    static var previews: some View {
        SignUpView(isAuth: $auth, userExist: $exist)
    }
}
