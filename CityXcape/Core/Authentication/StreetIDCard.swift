//
//  StreetIDCard.swift
//  CityXcape
//
//  Created by James Allan on 10/1/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct StreetIDCard: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var vm: UploadViewModel
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State var worlds: [World] = [World.demo, World.demo, World.demo]
    var body: some View {
        VStack {
            header()
            userView()
            
            worldList()
            passport()
            Spacer()
            
    
            
            Button {
                Task {
                    do {
                        try await vm.submitStreetPass()
                        dismiss()
                    } catch {
                        errorMessage = error.localizedDescription
                        showError.toggle()
                    }
                }
            } label: {
                Text("Create StreetPass")
                    .fontWeight(.thin)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 40)
                    .background(.blue)
                    .clipShape(Capsule())
            }

        }
        .background(background())
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach(vm.selectedWorlds) {
                WebImage(url: URL(string: $0.imageUrl))
                    .resizable()
                    .scaledToFit()
                    .colorInvert()
                    .frame(height: 55)
            }
        }
        .padding(.top, 25)
        
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
    
    @ViewBuilder
    func passport() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                //
            }, label: {
                HStack {
                    Image(systemName: "menucard.fill")
                        .font(.title)
                    
                    Text("Passport")
                        .font(.title)
                        .fontWeight(.thin)
                    
                }
                .foregroundStyle(.white)
            })
            
            Button(action: {
                //
            }, label: {
                HStack {
                    Image(systemName: "point.3.connected.trianglepath.dotted")
                        .font(.title)
                    
                    Text("Connections")
                        .font(.title2)
                        .fontWeight(.thin)
                    
                }
                .foregroundStyle(.white)
            })
        }
        .padding(.top, 20)
        
    }
  
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vm.city)
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
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            Button(action: {
                
            }, label: {
                    SelfieBubble(
                        size: 300,
                        url: vm.imageUrl,
                    pulse: 1.2)
            })
            
            
            VStack {
                Text(vm.username)
                    .font(.title)
                .fontWeight(.thin)
                
                Text("10 StreetCred")
                    .fontWeight(.thin)
                    .font(.callout)

            }
            .foregroundStyle(.white)

            
          
        }
    }
}

#Preview {
    StreetIDCard(vm: UploadViewModel())
}
