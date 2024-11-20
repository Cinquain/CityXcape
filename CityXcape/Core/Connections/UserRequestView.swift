//
//  UserRequestView.swift
//  CityXcape
//
//  Created by James Allan on 11/18/24.
//

import SwiftUI
import SDWebImageSwiftUI
import Shimmer

struct UserRequestView: View {
    
    @State var request: Request
    @StateObject var vm: RequestViewModel
    @Binding var index: Int
    
    @State private var worlds: [World] = []
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var isShimmering: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                header()
                userView()
                worldList()
                chatBubble()
                Spacer()
                ctaButtons()
            }
            .onAppear(perform: {
                showAnimation()
            })
            .background(background())
            
            if vm.showMatch {
                MatchAnimation(request: request, index: $index, vm: vm)
                    .animation(.easeInOut, value: vm.showMatch)
            }
           
          
        }
        .onDisappear(perform: {
            if vm.showTextField {
                vm.showTextField.toggle()
            }
        })
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("orange-paths")
                .resizable()
                .scaledToFill()
                .rotationEffect(Angle(degrees: 180))
                .opacity(0.8)
               
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func chatBubble() -> some View {
        ZStack {
            Text(request.content)
                .foregroundStyle(.black)
                .frame(width: 250, height: 40)
                .background(.orange.opacity(0.85))
                .clipShape(Capsule())
                .padding(.top, 20)
                .opacity(vm.showTextField ? 0 : 1)
                .animation(.easeIn, value: vm.showTextField)
                .alert(isPresented: $vm.showError, content: {
                    return Alert(title: Text(vm.errorMessage))
                })

            
            TextField("Send a message", text: $vm.message)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(width: 260, height: 40)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(Capsule())
                .padding(.top, 20)
                .opacity(vm.showTextField ? 1 : 0)
                .animation(.easeIn, value: vm.showTextField)

        }
    }
    @ViewBuilder
    func userView() -> some View {
        VStack {
            UserBubble(size: 300, url: request.imageUrl, pulse: 1.3)

            HStack {
                Spacer()
                Text(request.username)
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                  
                    Text(request.spotName.uppercased())
                        .foregroundStyle(.white)
                        .font(.caption)
                        .fontWeight(.thin)
                    .tracking(4)
                
                Text(Names.STREETPASS.rawValue)
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .tracking(4)
               
            }
            
            Spacer()

         
        }
        .padding(.horizontal, 22)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func ctaButtons() -> some View {
        HStack(spacing: 150) {
            Button {
                vm.removeRequest(request: request)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                    .frame(width: 70, height: 70)
                    .background(.red)
                    .clipShape(Circle())
            }
            
            Button {
                vm.acceptRequest(request: request)
            } label: {
                Image(systemName: "message.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                    .frame(width: 70, height: 70)
                    .background(.green)
                    .clipShape(Circle())
            }

        }
        .padding(.bottom, 20)
        
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach(request.worlds) { world in
                Button {
                    errorMessage = "\(request.username) is \(world.memberName)"
                    showError.toggle()
                } label: {
                    VStack {
                        WebImage(url: URL(string: world.imageUrl))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 65)
                        
                        Text(world.name)
                            .font(.callout)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .fontWeight(.light)
                            .frame(width: 55)
                    }
                    .shimmering(active: isShimmering, duration: 0.7, bounce: true)
                }

            }
        }
        .padding(.top, 10)
    }
    
    
    func showAnimation() {
        isShimmering = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            withAnimation {
                isShimmering = false
            }
        })
    }
    
    
}

#Preview {
   ContentView()
}
