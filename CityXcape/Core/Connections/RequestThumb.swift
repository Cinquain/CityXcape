//
//  RequestThumb.swift
//  CityXcape
//
//  Created by James Allan on 11/18/24.
//

import SwiftUI

struct RequestThumb: View {
    
    var request: Request
    var vm: ConnectionsVM
    @State var currentUser: User?
    
    var body: some View {
        HStack {
            
            Button(action: {
                Task {
                    self.currentUser = try await vm.loadUserStreetPass(request: request)
                }
            }, label: {
                VStack {
                    SelfieBubble(size: 100, url: request.imageUrl, pulse: 2)
                    Text(request.username)
                        .fontWeight(.light)
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                }
            })
            .sheet(item: $currentUser) { user in
                PublicStreetPass(user: user)
            }
          
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    HStack {
                        Text(request.content)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                        Spacer()
                    }
                    .padding()
                    .background(.blue.opacity(0.6))
                    .cornerRadius(8)
                }
              
                
                HStack {
                    Button {
                        vm.currentRequest = request
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            vm.showDrodown = true
                            vm.offset = 0
                        })
                    } label: {
                        Image(systemName: "message.fill")
                            .foregroundStyle(.blue)
                            .padding()
                            .background(.blue.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()

                    Button {
                        vm.removeRequest(request: request)
                    } label: {
                        HStack {
                            Image(systemName: "trash.circle.fill")
                                .foregroundStyle(.red)
                                .padding()
                                .background(.red.opacity(0.2))
                                .clipShape(Circle())
                           
                        }
                    }
                   
                }
                .padding(.horizontal, 8)
            }
            .padding(.horizontal, 5)
            
            Spacer()
        }
        .padding()
        .background(.black.opacity(0.6))
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
    RequestThumb(request: Request.demo, vm: ConnectionsVM())
}
