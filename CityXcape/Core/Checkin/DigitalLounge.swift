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
    @StateObject var vm: CheckinViewModel
 
    
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
            vm.checkIfStillCheckedIn()
        }
     
     
    }
    
    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack(spacing: 2) {
                Image(CXStrings.dotPerson)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                    
                
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
    func emptyState() -> some View {
        VStack {
            Spacer()
            SelfieBubble(size: 200, url: vm.user?.imageUrl ?? "", pulse: 2)
            Text(CXStrings.firstOne)
                .font(.title)
            
            Text(CXStrings.waitMessage)
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
        .padding(.top, 30)
        .sheet(item: $vm.currentUser) { user in
            PublicStreetPass(user: user, spot: spot)
        }
    }
    
    @ViewBuilder
    func userRow(user: User) -> some View {
        
        HStack(spacing: 30) {
       
            VStack(spacing: 2) {
                
                Button(action: {
                    vm.currentUser = user
                }, label: {
                    UserBubble(size: 100, url: user.imageUrl, pulse: 1)
                })
                
                Text(user.username)
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .font(.title3)
            }
            .padding(.top, 3)

           
            
            VStack(alignment: .center) {
            
                Button {
                    vm.currentUser = user
                } label: {
                    Text(CXStrings.viewSP)
                        .font(.callout)
                        .fontWeight(.light)
                        .foregroundStyle(.black)
                        .frame(width: 150, height: 35)
                        .background(.orange.opacity(0.8))
                        .clipShape(Capsule())
                }

               
                Spacer()
                    .frame(height: 25)
                    
                Divider()
                    .background(.white)
                    .frame(height: 0.3)
            }
            .foregroundStyle(.white)

          
            
            Spacer()
        }
        .padding(.horizontal, 10)

        
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
                Text(CXStrings.checkout)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
            }
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            
            Image(CXStrings.loungeBackground)
                .resizable()
                .scaledToFill()
                .opacity(0.6)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
  
    
    
}

#Preview {
    DigitalLounge(spot: Location.demo, vm: CheckinViewModel())
}
