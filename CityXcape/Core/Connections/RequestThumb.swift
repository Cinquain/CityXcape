//
//  RequestThumb.swift
//  CityXcape
//
//  Created by James Allan on 11/18/24.
//

import SwiftUI

struct RequestThumb: View {
    
    var request: Request
    var vm: RequestViewModel
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
                PublicStreetPass(user: user)
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
                        Image(systemName: "message.fill")
                            .foregroundStyle(.green)
                            .padding()
                            .background(.green.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    Spacer()

                    Button {
                        vm.removeRequest(request: request)
                    } label: {
                        HStack {
                            Image(systemName: "trash.fill")
                                .foregroundStyle(.orange)
                                .padding()
                                .background(.orange.opacity(0.2))
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
    RequestThumb(request: Request.demo, vm: RequestViewModel())
}
