//
//  RequestView.swift
//  CityXcape
//
//  Created by James Allan on 8/22/24.
//

import SwiftUI

struct RequestView: View {

    @Binding var index: Int
    @GestureState private var dragState: DragState = .inactive
    @StateObject var vm: RequestViewModel
    @State private var currentRequest: Request?
    
    var body: some View {
        VStack {
            header()
            
            if vm.requests.isEmpty {
                emptyState()
            } else {
                ZStack {
                    if !vm.cardViews.isEmpty {
                        ForEach(vm.cardViews) { cardView in
                            cardView
                                .zIndex(vm.isTopCard(cardView: cardView) ? 1 : 0)
                                .overlay(LikeorDislike(cardView: cardView))
                                .offset(x: vm.isTopCard(cardView: cardView) ? self.dragState.translation.width : 0, y: vm.isTopCard(cardView: cardView) ? self.dragState.translation.height : 0)
                                .scaleEffect(self.dragState.isDragging && vm.isTopCard(cardView: cardView) ? 0.85 : 1)
                                .rotationEffect(Angle(degrees: vm.isTopCard(cardView: cardView) ?  Double(dragState.translation.width / 12) : 0))
                                .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                                .offset(x: vm.isTopCard(cardView: cardView) ? vm.offset : 0)
                                .gesture(LongPressGesture(minimumDuration: 0.01)
                                                              .sequenced(before: DragGesture())
                                      .updating(self.$dragState, body: { (value, state, transaction) in
                                          switch value {
                                          case .first(true):
                                              state = .pressing
                                          case .second(true, let drag):
                                              state = .dragging(translation: drag?.translation ?? .zero)
                                          default:
                                              break
                                          }
                                      })
                                      .onEnded({ (value) in
                                          guard case .second(true, let drag?) = value else {return}
                                          if drag.translation.width < -vm.dragThreshold  && vm.isTopCard(cardView: cardView) {
                                              //User is dismissed
                                              currentRequest = cardView.request
                                              if let currentRequest {
                                                  vm.unmatch(request: currentRequest)
                                              }
                                          }
                                          if drag.translation.width > vm.dragThreshold  && vm.isTopCard(cardView: cardView){
                                              currentRequest = cardView.request
                                              if let currentRequest {
                                                  vm.match(request: currentRequest)
                                              }
                                              
                                          }
                                      })
                                  )
                            if vm.showMatch {
                                if let currentRequest {
                                    MatchAnimation(vm: vm, request: currentRequest, index: $index)
                                }
                            }
                        }
                    }
                    
                   
                }
            }
            
        }
        .background(background())
    }
    
  
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("hex-background")
                .resizable()
                .scaledToFit()
                .opacity(0.3)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func emptyState() -> some View {
        VStack {
            Spacer()
                .frame(height: 150)
            Image("honeycomb")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                
            
            Text("Scan CityXcape QR code to \n find people looking to meet")
                .foregroundStyle(.white)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
            
            Button {
               index = 0
            } label: {
                Text("Got it!")
                    .foregroundStyle(.black)
                    .fontWeight(.thin)
                    .frame(width: 150, height: 40)
                    .background(.orange)
                    .clipShape(Capsule())
                
            }

            Spacer()
        }
    }
    
    fileprivate func match(request: Request) {
        vm.offset = 1000
        if let index = vm.requests.firstIndex(of: request) {
            vm.requests.remove(at: index)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            withAnimation {
                vm.showMatch.toggle()
            }
        })
    }
    
    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack {
        
                Text(calculateTitle())
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 0.5)
                .background(.white)
                .padding(.horizontal)
        }
    }
    
    fileprivate func calculateTitle() -> String {
        if vm.requests.isEmpty {
            return "No Request Pending"
        } else {
            return "\(vm.requests.first?.username ?? "") Wants to Connect"
        }
    }
    
    @ViewBuilder
    func LikeorDislike(cardView: Cardview) -> some View {
        ZStack {
            VStack {
                Image(systemName: "hand.raised.slash.fill")
                    .modifier(swipeModifier())
                    .foregroundColor(.red)
                
                Text("Pass!")
                    .foregroundStyle(.red)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .opacity(dragState.translation.width < -vm.dragThreshold && vm.isTopCard(cardView: cardView) ? 1 : 0)
            
            VStack {
                Image(systemName: "heart.fill")
                    .modifier(swipeModifier())
                    .foregroundColor(.green)
                
                Text("Connect!")
                    .foregroundStyle(.green)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .opacity(dragState.translation.width > vm.dragThreshold && vm.isTopCard(cardView: cardView) ? 1 : 0)
        }
    }
    
    @ViewBuilder
    func ctaButton(request: Request) -> some View {
        VStack {
            Spacer()
            HStack {
            
                Button(action: {
                    vm.unmatch(request: request)
                }, label: {
                    Label("Pass", systemImage: "hand.raised.slash.fill")
                        .foregroundStyle(.red)
                })

                Spacer()

                Button(action: {
                    //Accept Match
                    vm.match(request: request)
                }, label: {
                    Label("Connect", systemImage: "powerplug.fill")
                        .foregroundColor(.green)
                })
                
            }
            .padding(.horizontal, 10)
        }
    }
    
    
}

#Preview {
    ContentView()
}
