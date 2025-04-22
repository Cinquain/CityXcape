//
//  RequestView.swift
//  CityXcape
//
//  Created by James Allan on 8/22/24.
//

import SwiftUI

struct Connections: View {

    @State var vm = ConnectionsVM()
    @Binding var index: Int
    
    
    var body: some View {
        
            VStack {
                header()
            
                ScrollView {
                    ForEach(vm.requests) { request in
                        RequestThumb(request: request, vm: vm)
                        .alert(isPresented: $vm.showError, content: {
                            return Alert(title: Text(vm.errorMessage))
                        })
                        
                        Divider()
                            .frame(height: 0.1)
                            .background(.white)
                    }
                }
                .opacity(vm.showDrodown ? 0 : 1)
                .refreshable {
                    vm.fetchPendingRequest()
                }
                
                
            }
            .opacity(vm.showDrodown ? 0 : 1)
            .animation(.easeOut, value: vm.showDrodown)
            .background(HexBackground())
            .overlay(content: {
                if vm.requests.isEmpty {
                    emptyState()
                }
                
                ResponseView(request: vm.currentRequest, vm: vm)
                    .offset(y: vm.offset)
                    .animation(.easeIn(duration: 0.3), value: vm.offset)
                                    
            })
            .onAppear(perform: {
                AnalyticService.shared.viewedRequest()
                vm.startListeningForRequest()
            })
            .onDisappear {
                vm.removeRequestListener()
            }
        
        
        
    }
    
  
    
   
    
    @ViewBuilder
    func emptyState() -> some View {
        VStack {
            Spacer()
                .frame(height: 200)
            Image("honeycomb")
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                
            
            Text("No Pending Connections")
                .foregroundStyle(.white)
                .font(.title3)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
            
            Button {
                vm.fetchPendingRequest()
            } label: {
                Text("Refresh")
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
                Spacer()
                Image("hexagons-3")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15)
                    .foregroundStyle(.white)
                    .padding(9)
                    .background(.white.opacity(0.2))
                    .clipShape(Circle())
                
                Text("CONNECTIONS")
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                    .tracking(3)

                
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 0.5)
                .background(.white)
                .padding(.horizontal)
        }
    }
        

    

    
    
}

#Preview {
    @Previewable @State var value: Int = 0
    Connections(vm: ConnectionsVM(), index: $value)
}
