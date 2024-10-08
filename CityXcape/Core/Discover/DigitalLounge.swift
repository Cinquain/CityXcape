//
//  Lounge.swift
//  CityXcape
//
//  Created by James Allan on 8/12/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct DigitalLounge: View {
    @AppStorage(CXUserDefaults.createdSP) var createdSP: Bool?
    @Environment(\.dismiss) private var dismiss
    
    var spot: Location
    
    @State private var showSP: Bool = false
    @State private var isShimmering: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showOnboarding: Bool = false
    @State private var signup: Bool = false
    
    var body: some View {
        VStack {
            header()
            guestList()
            Spacer()
        }
        .background(background())
        .edgesIgnoringSafeArea(.bottom)
     
    }
    
    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack {
                Image("honeycomb")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .fullScreenCover(isPresented: $signup, content: {
                        SignUp()
                    })
                
                Text("Devil's Advocate")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                    .alert(isPresented: $showError, content: {
                        Alert(title: Text(errorMessage),
                              primaryButton: .default(Text("Ok"), action: {
                            showOnboarding.toggle()
                        }),
                        secondaryButton: .cancel()
                        )
                    })
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.uturn.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(.white)
                        .fullScreenCover(isPresented: $showOnboarding, content: {
                            Onboarding()
                        })
                })
            }
            .padding(.horizontal, 10)
            
            Divider()
                .background(.white)
                .frame(height: 1)
                .padding(.horizontal, 10)
        }
    }
    
    @ViewBuilder
    func guestList() -> some View {
        ScrollView {
            ForEach(1..<30) { num in
              userRow()
            }
        }
        .padding(.top, 40)
        .sheet(isPresented: $showSP, content: {
            PublicStreetPass()
        })
    }
    
    @ViewBuilder
    func userRow() -> some View {
        HStack(spacing: 30) {
           
            Button(action: {
//                if AuthService.shared.uid == nil ||
//                    AuthService.shared.uid == "" {
//                    signup.toggle()
//                    return
//                }
                if createdSP == true {
                    showSP.toggle()
                } else {
                    errorMessage = "You need a StreetPass to message others"
                    showError.toggle()
                }
            }, label: {
                VStack(spacing: 2) {
                    UserDot(size: 100, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c")
                    Text("Alison")
                        .foregroundStyle(.white)
                        .fontWeight(.light)
                        .font(.title3)
                }
            })
            
            
            VStack(alignment: .leading) {
                Text("Looking for Friends")
                    .fontWeight(.light)
                Text("Checked in at 3:45")
                    .fontWeight(.light)
                Divider()
                    .background(.white)
                    .frame(height: 0.5)
            }
            .foregroundStyle(.white)

          
            
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            WebImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2F0pY5rXu0aG2ATVaRYT3A%2Fpexels-vardarious-3887985.jpg?alt=media&token=462afed3-608d-4762-bd37-bc88f7653430"))
                .resizable()
                .scaledToFill()
                .opacity(0.30)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    DigitalLounge(spot: Location.demo)
}
