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
    
    @AppStorage(CXUserDefaults.streetcred) var wallet : Int?
    @AppStorage(CXUserDefaults.lastSpotId) var lastSpot : String?

    @Environment(\.dismiss) private var dismiss
    
    var user: User
    
    @State private var message: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isShimmering: Bool = false
    @State private var showTextField: Bool = false
    @State private var buySTC: Bool = false
    @State private var isSent: Bool = false
    
    var body: some View {
        VStack {
            header()
            userView()
            worldList()
            messageField()
            Spacer()
            ctaButton()
        }
        .background(background())
        .onAppear {
            isShimmering = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                withAnimation {
                    isShimmering = false
                }
            })
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
                .shimmering(active: isShimmering, duration: 0.7, bounce: true)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Text("STREETPASS")
                .font(.system(size: 24))
                .fontWeight(.thin)
                .foregroundStyle(.white)
                .tracking(4)
                .padding(.top, 5)
            
            Spacer()
         
        }
        .padding(.horizontal, 22)
    }
    
    @ViewBuilder
    func messageField() -> some View {
        ZStack {
            TextField("  Send a message", text: $message)
                .frame(width: showTextField ? 250 : 0, height: 40)
                .background(.white)
                .clipShape(Capsule())
                .animation(.easeIn, value: showTextField)
                .padding(.top, 40)
            
            VStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                    .font(.largeTitle)
                Text("Sent!")
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
            }
            .opacity(isSent ? 1 : 0)
        }
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
            Button(action: {
                submitRequest()
            }, label: {
                Text(showTextField ? "Send" : "message")
                    .font(.title3)
                    .fontWeight(.thin)
                    .foregroundStyle(.black)
                    .frame(width: showTextField ? 100 : 200, height: 45)
                    .background(showTextField ? .green : .orange)
                    .clipShape(Capsule())
            })
            .sheet(isPresented: $buySTC, content: {
                BuySTC()
                    .presentationDetents([.height(370)])
            })
    }
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            UserBubble(size: 300, url: user.imageUrl, pulse: 1.3)
            
            Text(user.username)
                .font(.title)
                .foregroundStyle(.white)
                .fontWeight(.thin)
            
        }
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach(user.worlds) { world in
                Button {
                    errorMessage = world.name
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
                            .fontWeight(.thin)
                            .frame(width: 55)
                    }
                }

            }
        }
        .padding(.top, 10)
        
    }
    

    fileprivate func submitRequest() {
        if wallet == 0   {
            buySTC.toggle()
            return
        } else if !showTextField {
            showTextField.toggle()
            return
        } else {
            let locationId = lastSpot ?? ""
              Task {
                  do {
                      try await  DataService.shared.sendRequest(userId: user.id, spotId: locationId, message: message)
                      withAnimation {
                          message = ""
                          showTextField = false
                          isSent = true
                          SoundManager.shared.playBeep()
                      }
                      DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                          withAnimation {
                              isSent = false
                          }
                      })
                  } catch {
                      errorMessage = error.localizedDescription
                      showError.toggle()
                  }
              }
        }
    }
    
}

#Preview {
    PublicStreetPass(user: User.demo)
}
