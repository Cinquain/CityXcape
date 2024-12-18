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
                        UserDot(size: 100, url: user.imageUrl)
                        Text(user.username)
                            .foregroundStyle(.white)
                            .fontWeight(.light)
                            .font(.title3)
                    }
                    
                    VStack(alignment: .center) {
                        Text(vm.compare(worlds: user.worlds).0)
                            .fontWeight(.light)
                        Text(vm.compare(worlds: user.worlds).1)
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
                try await vm.checkout(spotId: spot.id)
                vm.showLounge = false
                dismiss()
            }
        } label: {
            Text("Checkout")
                .foregroundStyle(.black)
                .fontWeight(.thin)
                .frame(width: 120, height: 35)
                .background(.orange)
                .clipShape(Capsule())
                .padding(.bottom, 12)
            
        }

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
