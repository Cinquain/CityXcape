//
//  RequestThumb.swift
//  CityXcape
//
//  Created by James Allan on 11/18/24.
//

import SwiftUI

struct RequestThumb: View {
    
    var request: Request
    var vm: LocationViewModel
    @State var currentUser: User?
    
    var body: some View {
        HStack {
            
            Button(action: {
                Task {
                    self.currentUser = try await vm.loadUserStreetPass(request: request)
                }
            }, label: {
                VStack {
                    UserBubble(size: 100, url: request.imageUrl, pulse: 2)
                    Text(request.username)
                        .fontWeight(.thin)
                        .foregroundStyle(.white)
                }
            })
            .sheet(item: $currentUser) { user in
                PublicStreetPass(user: user, vm: vm)
            }
          
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    HStack {
                        Text(request.content)
                            .foregroundStyle(.black)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding()
                    .background(.orange.opacity(0.6))
                    .cornerRadius(8)
                }
              
                
                HStack {
                    Button {
                        vm.acceptRequest(request: request)
                    } label: {
                        Image("honeycomb")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        
                        Text("CONNECT")
                            .foregroundStyle(.white)
                            .tracking(2)
                            .fontWeight(.light)
                    }
                    
                    Spacer()

                    Button {
                        vm.removeRequest(request: request)
                    } label: {
                        HStack {
                            Image("trash")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(height: 30)
                           
                        }
                    }
                   
                }
                .padding(.horizontal, 8)
            }
            .padding(.horizontal, 5)
            
            Spacer()
        }
        .padding(10)
        .background(.black)
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("grid")
                .resizable()
            .scaledToFit()
            .opacity(0.7)
        }
    }
    
}

#Preview {
    RequestThumb(request: Request.demo, vm: LocationViewModel())
}
