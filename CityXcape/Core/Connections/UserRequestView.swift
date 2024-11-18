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
    @Binding var close: Bool
    
    @State private var worlds: [World] = []
    @State private var showMatch: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var isShimmering: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                header()
                userView()
                worldList()
                Spacer()
                message()
            }
            .onAppear(perform: {
                loadWorldsfor()
                showAnimation()
            })
            .background(background())
            
          
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
            
            Button {
                close = false 
            } label: {
                Image(systemName: "arrow.uturn.left.circle.fill")
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .opacity(0.8)
            }

         
        }
        .padding(.horizontal, 22)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func message() -> some View {
                Button {
                    //
                } label: {
                    HStack(spacing: 5) {
                        HStack {
                            Spacer()
                            Text(request.content)
                                .foregroundStyle(.black)
                                .lineLimit(2)
                            Spacer()
                        }
                        .padding(.vertical, 20)
                        .background(.gray)
                        .cornerRadius(8)
                        
                        Button {
                            showMatch.toggle()
                        } label: {
                            Image(systemName: "message.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.orange)
                               
                        }
                        
                    }
                }
                .padding(.horizontal, 50)
        
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach(worlds) { world in
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
    
    func loadWorldsfor() {
        Task {
            for key in request.worlds {
                let world = try await DataService.shared.getWorldFor(id: key)
                self.worlds.append(world)
            }
        }
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
    RequestView(vm: RequestViewModel())
}
