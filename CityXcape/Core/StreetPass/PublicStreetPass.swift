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
    
    var user: User
    @State var worlds: [World] = []
    
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
           showAnimation()
           loadWorlds()
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
            TextField("  Send a message", text: $message)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(width: showTextField ? 250 : 0, height: 40)
                .foregroundStyle(.black)
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
                checkForStreetCred()
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
            ForEach(worlds) { world in
                Button {
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
    
    func loadWorlds() {
        Task {
            for key in user.worlds {
                let world = try await DataService.shared.getWorldFor(id: key)
                self.worlds.append(world)
            }
        }
    }
    
    fileprivate func checkForStreetCred() {
        if showTextField {
            submitRequest()
            return
        }
        Task {
            do {
               let value = try await DataService.shared.getStreetCred()
                if value > 0 {
                    submitRequest()
                } else {
                    buySTC.toggle()
                    return
                }
            } catch {
                print("Error fetching STC", error.localizedDescription)
            }
        }
    }
    

    fileprivate func submitRequest() {
       if !showTextField {
            showTextField.toggle()
            return
        }
      if message.isEmpty {
            errorMessage = "Please enter a message"
            showError.toggle()
            return
        }
        
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

#Preview {
    PublicStreetPass(user: User.demo)
}
