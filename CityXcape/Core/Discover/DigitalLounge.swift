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
 
    
    var body: some View {
        VStack {
            header()
            guestList()
            Spacer()
            checkoutButton()
        }
        .background(background())
        .overlay {
            if vm.users.isEmpty {
                emptyState()
            }
        }
        .onAppear {
            vm.startListeningForRequest()
        }
        .onDisappear {
            vm.removeRequestListener()
        }
     
    }
    
    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack(spacing: 2) {
                Image("dot person")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                    
                
                Text("\(spot.name)")
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
    func emptyState() -> some View {
        VStack {
            Spacer()
            SelfieBubble(size: 200, url: vm.user?.imageUrl ?? "", pulse: 2)
            Text("First One Here!")
                .font(.title)
            
            Text("Please wait for more \n people to check in")
                .font(.title2)
                .multilineTextAlignment(.center)
                
            Spacer()
        }
        .foregroundStyle(.white)
        .fontWeight(.thin)
    }
    
    @ViewBuilder
    func guestList() -> some View {
        ScrollView {
            ForEach(vm.users) { user in
                userRow(user: user)
            }
        }
        .padding(.top, 40)
        .sheet(item: $vm.currentUser) { user in
            PublicStreetPass(user: user, vm: vm)
        }
    }
    
    @ViewBuilder
    func userRow(user: User) -> some View {
        
            Button(action: {
                vm.currentUser = user
            }, label: {
                HStack(spacing: 30) {
                    VStack(spacing: 2) {
                        UserBubble(size: 100, url: user.imageUrl, pulse: 1)
                        Text(user.username)
                            .foregroundStyle(.white)
                            .fontWeight(.light)
                            .font(.title3)
                    }
                    .padding(.top, 3)
                    
                    VStack(alignment: .center) {
                    
                        Text("View StreetPass")
                            .font(.callout)
                            .fontWeight(.light)
                            .foregroundStyle(.black)
                            .frame(width: 140, height: 30)
                            .background(.orange.opacity(0.8))
                            .clipShape(Capsule())
                        
                        Text(vm.compare(user: user).1)
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
    func checkoutButton() -> some View {
        Button {
            Task {
                try await vm.checkout(spot.id)
                vm.showLounge = false
                dismiss()
            }
        } label: {
            VStack {
                Image(systemName: "bell.badge.fill")
                    .font(.title)
                    .foregroundStyle(.white)
                Text("Check Out")
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
            }
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            
            Image("chrome honey")
                .resizable()
                .scaledToFill()
                .opacity(0.3)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
  
    
    
}

#Preview {
    DigitalLounge(spot: Location.demo, vm: LocationViewModel())
}
