//
//  RequestView.swift
//  CityXcape
//
//  Created by James Allan on 8/22/24.
//

import SwiftUI

struct RequestView: View {

    @GestureState private var dragState: DragState = .inactive
    @StateObject var vm: RequestViewModel
    @State private var currentRequest: Request?
    @State private var showPage: Bool = false
    @State private var scale: Double  = 0
    var body: some View {
        ZStack {
            VStack {
                    header()
                    if vm.requests.isEmpty {
                        emptyState()
                    } else {
                        ScrollView {
                            ForEach(vm.requests) { request in
                                Button {
                                    currentRequest = request
                                    showPage.toggle()
                                    scale  = 1
                                } label: {
                                    RequestThumb(request: request)
                                }

                            }
                        }
                    }
                 
                }
                .background(HexBackground())
            
            if showPage {
                if let requests = currentRequest {
                    withAnimation(.easeIn(duration: 0.5)) {
                        UserRequestView(request: requests, close: $showPage)
                            .transition(.move(edge: .leading))
                            .animation(.easeIn(duration: 0.4), value: showPage)
                    }
                }
                                
            }
            
        }
        
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
    RequestView(vm: RequestViewModel())
}
