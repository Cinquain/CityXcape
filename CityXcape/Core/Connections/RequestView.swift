//
//  RequestView.swift
//  CityXcape
//
//  Created by James Allan on 8/22/24.
//

import SwiftUI

struct RequestView: View {

    @StateObject var vm: LocationViewModel
    @Binding var index: Int
    
    
    @GestureState private var dragState: DragState = .inactive
    @State private var currentRequest: Request?
    var body: some View {
            VStack {
                    header()
                    if vm.requests.isEmpty {
                        emptyState()
                            
                    } else {
                        ScrollView {
                            ForEach(vm.requests) { request in
                                Button {
                                    currentRequest = request
                                } label: {
                                    RequestThumb(request: request, vm: vm)
                                       
                                }
                                .alert(isPresented: $vm.showError, content: {
                                    return Alert(title: Text(vm.errorMessage))
                                })

                            }
                        }
                        .refreshable {
                            vm.fetchPendingRequest()
                        }
                    }
                 
                }
                .background(HexBackground())
            
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
                Image("honeycomb")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
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
        } else if vm.requests.count == 1 {
            return "\(vm.requests.count) Person Wants to Connect"
        } else {
            return "\(vm.requests.count) People Want to Connect"
        }
    }
    

    

    
    
}

#Preview {
    ContentView()
}
