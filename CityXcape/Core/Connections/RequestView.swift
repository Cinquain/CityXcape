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
    @State var requests: [Request] = []
    @State private var offset: CGFloat = 0
    var dragThreshold: CGFloat = 65.0
    
    var body: some View {
        VStack {
            header()
            
            if requests.isEmpty {
                emptyState()
            } else {
                ZStack {
                    if !requests.isEmpty {
                        ForEach(requests) {
                            Cardview(request: $0)
                                .zIndex(1)
                                .overlay(LikeorDislike())
                                .offset(x: self.dragState.translation.width, y: self.dragState.translation.height)
                                .scaleEffect(self.dragState.isDragging ? 0.85 : 1)
                                .rotationEffect(Angle(degrees:  Double(dragState.translation.width / 12)))
                                .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                                .offset(x: offset)
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
                                          if drag.translation.width < -self.dragThreshold {
                                              //User is dismissed
                                          }
                                          if drag.translation.width > self.dragThreshold {
                                              offset = 1000
                                              
                                          }
                                      })
                                  )
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
                
            
            Text("Check-in a location with a CityXcape \n QR code to find people looking to meet")
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
        if requests.isEmpty {
            return "No Request Pending!"
        } else {
            return "\(Request.demo.username) Wants to Connect"
        }
    }
    
    @ViewBuilder
    func LikeorDislike() -> some View {
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
            .opacity(dragState.translation.width < -dragThreshold ? 1 : 0)
            
            VStack {
                Image(systemName: "heart.fill")
                    .modifier(swipeModifier())
                    .foregroundColor(.green)
                
                Text("Connect!")
                    .foregroundStyle(.green)
                    .font(.title2)
                    .fontWeight(.medium)
            }
            .opacity(dragState.translation.width > dragThreshold ? 1 : 0)
        }
    }
    
    
}

#Preview {
    ContentView()
}
