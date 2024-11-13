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
    @StateObject var vm: LocationViewModel
 
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
            vm.fetchCheckedInUsers(spotId: spot.id)
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
                    
                
                Text(spot.name)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
              
                
                Spacer()
                
               
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
            ForEach(vm.users) { user in
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
           
            Button(action: {
                currentUser = user
            }, label: {
                HStack(spacing: 30) {
                    VStack(spacing: 2) {
                        UserDot(size: 100, url: user.imageUrl)
                        Text(user.username)
                            .foregroundStyle(.white)
                            .fontWeight(.light)
                            .font(.title3)
                    }
                    
                    VStack(alignment: .center) {
                        Text("Two Worlds in Common")
                            .fontWeight(.light)
                        Text("50% Match")
                            .fontWeight(.medium)
                        Divider()
                            .background(.white)
                            .frame(height: 0.5)
                    }
                    .foregroundStyle(.white)

                  
                    
                    Spacer()
                }
                .padding(.horizontal, 10)

            })
        
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            WebImage(url: URL(string: spot.imageUrl))
                .resizable()
                .scaledToFill()
                .opacity(0.30)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
  
    
    
}

#Preview {
    DigitalLounge(spot: Location.demo, vm: LocationViewModel())
}
