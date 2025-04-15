//
//  RapSheet.swift
//  CityXcape
//
//  Created by James Allan on 2/18/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct RapSheet: View {
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var user: User
    
    var body: some View {
                
            VStack {
                HStack {
                    Spacer()
                   
                    Text("\(user.username)'s Rap Sheet")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .alert(isPresented: $showError) {
                            return Alert(title: Text(errorMessage))
                        }
                    Image("files")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22)
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
            ZStack(alignment: .top) {
                Color.black

                Image("Great Seal")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .opacity(0.12)
                    .rotationEffect(Angle(degrees: -45))
                    .padding(.top, 10)
                
                
            }
            .frame(width: size.width, height: size.height)

        }
    }
    
    @ViewBuilder
    func worldItem(world: World) -> some View {
        HStack(spacing: 5) {
            VStack {
                WebImage(url: URL(string: world.imageUrl))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 55)
                Text(world.name)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
            }
            
            
            
            
        }
        .contentMargins(10)

    }


        
    }

    
 

#Preview {
    RapSheet(user: User.demo)
}
