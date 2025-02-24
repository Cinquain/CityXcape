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
    
    @AppStorage(CXUserDefaults.lastSpotId) var lastSpot : String?
    @Environment(\.dismiss) private var dismiss

    @State var user: User
    @StateObject var vm: LocationViewModel
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isShimmering: Bool = false
    @State private var buySTC: Bool = false
    
    var body: some View {
        
        GeometryReader { geo in
            VStack {
                header()
                UserBubble(size: geo.size.width * 0.75, url: user.imageUrl, pulse: 1.3)
                
                Text(user.username)
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                    .padding(.top, -5)
                
                
                VStack(spacing: 10) {
                    ProgressView(size: 100, thickness: 15, font: .callout, value: Int(vm.compare(user: user).2))
                    Button {
                        vm.showRapSheet.toggle()
                    } label: {
                        Text(vm.compare(user: user).0)
                            .foregroundStyle(.white)
                            .font(.callout)
                            .fontWeight(.light)
                    }
                    .sheet(isPresented: $vm.showRapSheet) {
                        RapSheet(vm: vm, user: user)
                            .presentationDetents([.height(330)])
                    }

                }
                .padding(.top, 50)
                
                messageField()
                Spacer()
                ctaButton()
            }
            .onAppear {
               showAnimation()
               AnalyticService.shared.viewStreetPass()
            }
            .onDisappear {
                vm.showTextField = false
            }
        
        }
        .background(background())

       
      
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
    
    func showAnimation() {
        isShimmering = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
            withAnimation {
                isShimmering = false
            }
        })
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
                Text(Names.STREETPASS.rawValue)
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .tracking(4)
                    .alert(isPresented: $showError, content: {
                        return Alert(title: Text(errorMessage))
                })
            }
            
            Spacer()

         
        }
        .padding(.horizontal, 22)
        .padding(.top, 10)
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
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                Text("\(vm.stcValue - 1) StreetCred")
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
            }
            .opacity(vm.isSent ? 1 : 0)
        }
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
                
            Button(action: {
                checkForStreetCred()
            }, label: {
                Text(vm.showTextField ? "Send Request" : "CONNECT")
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundStyle(.black)
                    .frame(width:  200, height: 45)
                    .background(vm.showTextField ? .green : .orange)
                    .clipShape(Capsule())
            })
            .sheet(isPresented: $buySTC, content: {
                BuySTC(user: user)
                    .presentationDetents([.height(370)])
            })
    }
    
  
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach(user.worlds) { world in
                Button {
                    AnalyticService.shared.viewedWorld()
                    errorMessage = "\(user.username) is \(world.memberName)"
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

    
    fileprivate func checkForStreetCred() {
        if vm.showTextField {
            vm.sendRequest(uid: user.id)
            return
        }
        
        Task {
            do {
                vm.stcValue = try await DataService.shared.getStreetCred()
                if vm.stcValue > 0 {
                    vm.showTextField = true
                } else {
                    buySTC.toggle()
                    return
                }
            } catch {
                print("Error fetching STC", error.localizedDescription)
            }
        }
    }
    

  
    
}

#Preview {
    PublicStreetPass(user: User.demo, vm: LocationViewModel())
}
