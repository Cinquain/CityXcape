//
//  PublicStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/2/24.
//

import SwiftUI
import Shimmer
import SDWebImageSwiftUI

struct PublicStreetPass: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var vm = PublicSPViewModel()
    
    @State var user: User
    var spot: Location?
    
    
    var body: some View {
        
        VStack {
            header()
            userView()
            matchPercentage()
            messageField()
            Spacer()
            if spot != nil {
                ctaButton()
            }
        }
        .background(background())
        .onAppear {
           AnalyticService.shared.viewStreetPass()
        }
        .onDisappear {
            vm.showTextField = false
        }
        
      
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
    func header() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(user.city)
                    .foregroundStyle(.white)
                    .font(.caption)
                    .fontWeight(.thin)
                    .tracking(4)
                Text(CXStrings.streetpass)
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .tracking(4)
                    .alert(isPresented: $vm.showError, content: {
                        return Alert(title: Text(vm.errorMessage))
                })
            }
            
            Spacer()

         
        }
        .padding(.horizontal, 22)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func userView() -> some View {
        UserBubble(size: 320, url: user.imageUrl, pulse: 1.3)
        
        Text(user.username)
            .font(.title)
            .foregroundStyle(.white)
            .fontWeight(.thin)
            .padding(.top, -5)
            .opacity(vm.showWorlds ? 0 : 1)
            .animation(.easeIn, value: vm.showWorlds)
    }
    
    @ViewBuilder
    func matchPercentage() -> some View {
        VStack(spacing: 10) {
            
            if vm.compare(user: user).2 > 0 {
                CircularProgressView(size: 100, thickness: 15, font: .callout, value: Int(vm.compare(user: user).2))
            }
            
            
            
            Button {
                vm.showWorlds.toggle()
            } label: {
                
                HStack(spacing: 4) {
                    
                    
                    Text("Social Circle")
                        .foregroundStyle(.orange)
                        .font(.callout)
                        .fontWeight(.thin)
                    
                    Image("honeycomb")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                       
                }
                .frame(width: 150, height: 50)
                .background(Color.black.opacity(0.9))
                .clipShape(Capsule())
                .sheet(isPresented: $vm.showWorlds) {
                    WorldView(user: user)
                        .presentationDetents([.height(330)])
                }
            }
        }
        .padding(.top, 50)
    }
    
    @ViewBuilder
    func messageField() -> some View {
        ZStack {
            TextField("  Send a message", text: $vm.message)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(width: vm.showTextField ? 250 : 0, height: 40)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(Capsule())
                .animation(.easeIn, value: vm.showTextField)
                .padding(.top, 40)
            
            VStack {
                Image("StreetCred")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .clipShape(Circle())
                
                Text("\(vm.walletValue - 1) StreetCred")
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
            }
            .opacity(vm.isSent ? 1 : 0)
        }
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
                
            Button(action: {
                vm.checkForStreetCred(uid: user.id)
            }, label: {
                (Text(vm.showTextField ? "Send Request" : "CONNECT ") + Text(Image(systemName: "powerplug.fill")))
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundStyle(.black)
                    .frame(width:  200, height: 45)
                    .background(vm.showTextField ? .green : .orange)
                    .clipShape(Capsule())
            })
            .sheet(isPresented: $vm.buySTC, content: {
                BuySTC(usecase: .connect, spot: spot!)
                    .presentationDetents([.height(370)])
            })
    }
    

    
  
    
    
    

  
    
}

#Preview {
    PublicStreetPass(user: User.demo)
}
