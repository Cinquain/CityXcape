//
//  OnboardingI.swift
//  CityXcape
//
//  Created by James Allan on 8/11/23.
//

import SwiftUI
import AsyncButton

struct StartScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSP: Bool = false
    @State private var showSignUp: Bool = false
    @State var isAuth: Bool = false
    @State var idCreated: Bool = false 
    
    @State private var showError: Bool = false
    @State private var error: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            HStack {
                Spacer()
                Text("Find Secret Spots")
                    .font(.title2)
                    .fontWeight(.thin)
                    .foregroundColor(.white)
                    .padding(.top, -6)
                Spacer()
            }
            .padding(.bottom, 40)
            .alert(isPresented: $showError) {
                Alert(title: Text(error))
            }
            
            VStack(spacing: 8) {
                Button {
                    showSignUp.toggle()
                } label: {
                    Label("Authenticate", systemImage: isAuth ? "checkmark" : "circle")
                        .foregroundColor(.black)
                        .fontWeight(.thin)
                        .frame(width: 200, height: 40)
                        .background(.white.opacity(0.8))
                        .clipShape(Capsule())
                      
                }
                .fullScreenCover(isPresented: $showSignUp) {
                    SignUpView(isAuth: $isAuth)
                }
                
                Button {
                    loadStreetPass()
                } label: {
                    Label("Get StreetPass", systemImage: idCreated ? "checkmark" : "circle")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .frame(width: 200, height: 40)
                        .background(.blue)
                        .clipShape(Capsule())
                }
                .fullScreenCover(isPresented: $showSP) {
                    CreateStreetPass(idCreated: $idCreated)
                }
               
               
            }

            Spacer()
            
            if idCreated {
                withAnimation {
                    DismissButton()
                }
            }
        }
        .background(Background())
        .edgesIgnoringSafeArea(.all)
        
    }
   
    fileprivate func loadStreetPass() {
        if AuthService.shared.uid == nil {
            error = "Please sign up before creating a StreetPass"
            showError.toggle()
        } else {
            showSP.toggle()
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
                .padding(.bottom, 35)
        }
    }
   
    
    
    @ViewBuilder
    func Background() -> some View {
        GeometryReader {
            let size  = $0.size
            Image("hex-background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .black.opacity(0.1),
                                .black.opacity(0.2),
                                .black.opacity(0.8),
                                .black], startPoint: .bottom, endPoint: .top))
                            .frame(height: size.height)
                    }
                }
        }
    }
    
}

struct OnboardingI_Previews: PreviewProvider {
    @State static var streetPass: Bool = false
    static var previews: some View {
        StartScreen()
    }
}
