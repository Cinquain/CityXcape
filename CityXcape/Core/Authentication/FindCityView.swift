//
//  FindCityView.swift
//  CityXcape
//
//  Created by James Allan on 9/28/24.
//

import SwiftUI

struct FindCityView: View {
    
    @Binding var selection: Int
    @StateObject var vm: UploadViewModel
    @StateObject var manager = LocationService.shared
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var city: String = ""

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
                HStack(spacing: 2) {
                    
                    Image(systemName: "forward.fill")
                        .foregroundStyle(.white)
                        .font(.callout)
                }
                .frame(width: 55, height: 55)
                .background(.blue)
                .clipShape(Circle())
            })
            .padding(.top, 45)
            
            Spacer()
        }
        .background(background())
        .onAppear {
            manager.getCity()
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("colored-paths")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    fileprivate func submitLocation() {
        
        if vm.city.isEmpty  {
            manager.getCity()
            vm.updateCity()
            return
        }
        
        withAnimation {
            selection = 2
        }
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                
                Text(LocationService.shared.city)
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
    
   
}

#Preview {
    Onboarding()
}
