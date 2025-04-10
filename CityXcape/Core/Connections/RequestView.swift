//
//  RequestView.swift
//  CityXcape
//
//  Created by James Allan on 8/22/24.
//

import SwiftUI

struct RequestView: View {

    @State var vm = RequestViewModel()
    @Binding var index: Int
    
    
    var body: some View {
        ZStack {
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
                .refreshable {
                    vm.fetchPendingRequest()
                }
                
                
            }
            .opacity(vm.showMatch ? 0 : 1)
            .background(HexBackground())
            .overlay(content: {
                if vm.requests.isEmpty {
                    emptyState()
                }
            })
          
            
            if vm.showMatch {
                
                MatchAnimation(vm: vm)
            }
            
            //End of Zstack
        }
        .onAppear(perform: {
            AnalyticService.shared.viewedRequest()
        })
        .onDisappear {
            //Remive request listener
            
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
    HomeView()
}
