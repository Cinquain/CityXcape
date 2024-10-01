//
//  RequestView.swift
//  CityXcape
//
//  Created by James Allan on 8/22/24.
//

import SwiftUI

struct RequestView: View {
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 180))
    ]
    @State private var showRequest: Bool = false
    var body: some View {
        VStack {
            header()
            
            scrollView()
        }
        .background(background())
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("hex-background")
                .resizable()
                .scaledToFill()
                .opacity(0.3)
        }
        .edgesIgnoringSafeArea(.all)

    }
    
    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack {
                Text("1")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                    .frame(width: 30, height: 30)
                    .background(.red)
                    .clipShape(Circle())
                Text("Want to Connect")
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
    
    @ViewBuilder
    func scrollView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, content: {
                Button(action: {
                    showRequest.toggle()
                }, label: {
                    RequestThumb()
                })
                .fullScreenCover(isPresented: $showRequest, content: {
                    Cardview(request: Request.demo)
                })
            })
        }
        .padding(.top, 20)
    }
}

#Preview {
    RequestView()
}
