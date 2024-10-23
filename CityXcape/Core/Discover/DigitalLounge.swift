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
    @State private var users: [User] = [User.demo, User.demo, User.demo]
    @State private var currentUser: User?
    
    var body: some View {
        VStack {
            header()
            guestList()
            Spacer()
        }
        .background(background())
        .edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: {
            setSpotId()
        })
     
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
                            signup.toggle()
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
            ForEach(users) { user in
                userRow(user: user)
            }
        }
        .padding(.top, 40)
        .sheet(item: $currentUser) { user in
            PublicStreetPass(user: user)
        }
    }
    
    @ViewBuilder
    func userRow(user: User) -> some View {
        HStack(spacing: 30) {
           
            Button(action: {
                if AuthService.shared.uid == nil ||
                    AuthService.shared.uid == "" {
                    errorMessage = "You need an account to view profile"
                    showError.toggle()
                    return
                }
                
                
             
            }, label: {
                VStack(spacing: 2) {
                    UserDot(size: 100, url: user.imageUrl)
                    Text(user.username)
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
    
    fileprivate func setSpotId() {
        UserDefaults.standard.set(spot.id, forKey: CXUserDefaults.lastSpotId)
    }
}

#Preview {
    DigitalLounge(spot: Location.demo)
}
