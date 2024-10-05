//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/2/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct StreetPass: View {
    @AppStorage(CXUserDefaults.profileUrl) var profileUrl: String?
    @State private var showPasport: Bool = false
    
    var body: some View {
        VStack {
            header()
            userView()
            Spacer()
                .frame(maxHeight: 50)
            worldList()
            passport()
            Spacer()
        }
        .background(background())
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
            
            Button(action: {}, label: {
                Image(systemName: "gearshape.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.5))
            })
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach([World.demo2, World.demo, World.demo3]) { world in
                Button {
                    //
                } label: {
                    WebImage(url: URL(string: world.imageUrl))
                        .resizable()
                        .scaledToFit()
                        .colorInvert()
                        .frame(height: 65)
                }

            }
        }
        
    }
    
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            Button(action: {
                
            }, label: {
                    SelfieBubble(
                        size: 300,
                        url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FIMG_1575.png?alt=media&token=100ea308-bcb1-41cf-b53e-dc663a3f6692",
                    pulse: 1.2)
            })
            
            
            VStack {
                Text("Cinquain")
                    .font(.title)
                .fontWeight(.thin)
                
                Text("100 StreetCred")
                    .fontWeight(.thin)
                    .font(.callout)

            }
            .foregroundStyle(.white)

            
          
        }
    }
    
    @ViewBuilder
    func passport() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                showPasport.toggle()
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
        .fullScreenCover(isPresented: $showPasport, content: {
            PassportPage()
        })
        .padding(.top, 20)
    }
    
    func openCustom(url: String) {
        guard let url = URL(string: url) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}

#Preview {
    StreetPass()
}
