//
//  SignUp.swift
//  CityXcape
//
//  Created by James Allan on 8/5/24.
//

import SwiftUI

struct SignUp: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack {
            headerView()
            Spacer()
                .frame(height: 50)
            signInButtons()
            Spacer()
            dismissButton()

        }
        .background(background())
    }
    
    
    @ViewBuilder
    func headerView() -> some View {
        Image("Broken Pin")
            .resizable()
            .scaledToFit()
            .frame(width: 300)
            .clipShape(Circle())
            .shadow(color: .orange, radius: 10)
        
    
    }
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("hex-background")
                .resizable()
                .scaledToFit()
                .opacity(0.2)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func signInButtons() -> some View {
        VStack {
            HStack {
                Spacer()
                Text("SIGN IN WITH")
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                    .padding(.top, 9)
                    .tracking(5)
                Spacer()
            }
            
            HStack(spacing: 25) {
                Button(action: {}, label: {
                    Image("Google-Symbol")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 55)
                })
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image("apple-emblem")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75)
                        .clipShape(Circle())
                })
            }
        }
    }
    
    @ViewBuilder
    func dismissButton() -> some View {
        Button(action: {
            dismiss()
        }, label: {
            Text("DISMISS")
                .font(.caption)
                .fontWeight(.light)
                .foregroundStyle(.black)
                .frame(width: 120, height: 40)
                .background(.white.opacity(0.8))
                .clipShape(Capsule())
        })
    }
    
    
}

#Preview {
    SignUp()
}