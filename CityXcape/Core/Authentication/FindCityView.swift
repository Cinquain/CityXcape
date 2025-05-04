//
//  FindCityView.swift
//  CityXcape
//
//  Created by James Allan on 9/28/24.
//

import SwiftUI

struct FindCityView: View {
    
    @Binding var index: Int
    @StateObject var vm: AuthViewModel
    var manager = LocationService.shared
    @State private var isDone: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false

    var body: some View {
        VStack {
            header()
            
            Spacer()
            HStack {
                Text("Let's Find Your City")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.thin)
                    .alert(isPresented: $showError, content: {
                        Alert(title: Text(errorMessage))
                    })
            }
            
      
            MapViewRepresentable()
                .colorScheme(.dark)
                .frame(width: 400, height: 300)
                .cornerRadius(12)
            
            Button(action: {
                manager.checkAuthorizationStatus()
                
            }, label: {
                Text("Find Me")
                    .foregroundStyle(.black)
                    .fontWeight(.thin)
                    .font(.title3)
                    .frame(width: 200, height: 40)
                    .background(.yellow)
                    .clipShape(Capsule())
            })
            .padding(.top, 10)
            
            Button(action: {
              submitLocation()
            }, label: {
                Label("Done", systemImage: "checkmark.shield.fill")
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .frame(width: 125, height: 35)
                    .background(manager.status == .authorizedWhenInUse ? .green : .gray)
                    .animation(.easeIn, value: isDone)
                    .clipShape(Capsule())
            })
            .padding(.top, 45)

            
            Spacer()
        }
        .background(SPBackground())
        .onAppear {
            manager.getCity()
        }
        
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(manager.city)
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .tracking(4)
                
                Text("STREETPASS")
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .tracking(4)
                    .opacity(0.7)
                
            }
            .foregroundStyle(.white)
            Spacer()
            
        }
        .padding(.horizontal, 20)
    }
    
    fileprivate func submitLocation() {
        
        if manager.status == .denied {
            vm.errorMessage = "CityXcape needs location permission"
            vm.showError.toggle()
            return
        }
        
        withAnimation {
            index = 4
        }
    }
    
    
   
}

#Preview {
    Onboarding()
}
