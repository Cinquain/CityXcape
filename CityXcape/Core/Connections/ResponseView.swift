//
//  ResponseView.swift
//  CityXcape
//
//  Created by James Allan on 4/15/25.
//

import SwiftUI

struct ResponseView: View {
    
    var request: Request?
    @State var vm: ConnectionsVM
    
    var body: some View {
        VStack {
            Spacer()
            
            userInfo()
            submitButtons()
            Spacer()
        }
        .background(background())
      
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
                .opacity(0.3)
          
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func userInfo() -> some View {
        VStack(spacing: 0) {
            SelfieBubble(size: 300, url: request?.imageUrl ?? "", pulse: 1)
                .alert(isPresented: $vm.showError) {
                    Alert(title: Text(vm.errorMessage))
                }
            HStack {
                Text(request?.username ?? "")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
            }
        }
    }
    
    @ViewBuilder
    func submitButtons() -> some View {
        VStack(spacing: 10) {
            TextField("Write an answer", text: $vm.message)
                .padding()
                .background(.white)
                .frame(width: 250, height: 40)
                .opacity(vm.isSent ? 0 : 1)
                .clipShape(Capsule())
            
            
            HStack {
                Spacer()
                Button {
                    vm.acceptRequest(request: request)
                } label: {
                    Text(vm.isSent ? "Sent" : "message")
                        .fontWeight(.thin)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 150, height: 40)
                        .background(vm.isSent ? .green : .blue)
                        .clipShape(Capsule())
                    
                }
                
                Button {
                    vm.offset = -900
                    vm.showDrodown = false
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle.fill")
                        .font(.system(size: 35))
                        .foregroundStyle(.white)
                }

                Spacer()
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    ResponseView(request: Request.demo, vm: ConnectionsVM())
}
