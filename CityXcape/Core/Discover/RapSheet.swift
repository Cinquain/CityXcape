//
//  RapSheet.swift
//  CityXcape
//
//  Created by James Allan on 2/18/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct RapSheet: View {
    
    @StateObject var vm: LocationViewModel
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    var user: User
    var body: some View {
                
            VStack {
                HStack {
                    Spacer()
                    Image("honeycomb")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                    Text("\(user.username)'s World")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .alert(isPresented: $showError) {
                            return Alert(title: Text(errorMessage))
                        }
                    Spacer()
                }
                .padding(.top, 10)
                
                Divider()
                    .frame(height: 1)
                    .foregroundStyle(.white)
                
                
                    ForEach(user.worlds) { world in
                        
                        Button {
                            errorMessage = "\(user.username) is part of the \(world.name) world"
                            showError.toggle()
                        } label: {
                            worldItem(world: world)
                        }

                        
                    }
                
                
                Spacer()
                
                

            }
            .cornerRadius(12)
            .background(background())
            .edgesIgnoringSafeArea(.bottom)

                
        }
    
    @ViewBuilder
    func background() -> some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                Color.black

                Image("black-paths")
                    .resizable()
                    .scaledToFill()
                
                
            }
            .frame(width: size.width, height: size.height)

        }
    }
    
    @ViewBuilder
    func worldItem(world: World) -> some View {
        VStack(spacing: 5) {
            WebImage(url: URL(string: world.imageUrl))
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            Text(world.name)
                .font(.callout)
                .foregroundStyle(.white)
                .fontWeight(.thin)
            
        }
        .contentMargins(10)

    }


        
    }

    
 

#Preview {
    RapSheet(vm: LocationViewModel(), user: User.demo)
}
