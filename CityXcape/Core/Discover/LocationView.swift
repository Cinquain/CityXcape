//
//  LocationView.swift
//  CityXcape
//
//  Created by James Allan on 8/10/24.
//

import SwiftUI
import SDWebImageSwiftUI


struct LocationView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showStamp: Bool = false
    @State private var showInfo: Bool = false
    @State private var showLounge: Bool = false
    @State private var alert: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            GeometryReader {
                let size = $0.size
                VStack(spacing: 10) {
                    mainImage(size: size)
                    Spacer()
                    checkinButton()
                }
                .background(.black)
                .edgesIgnoringSafeArea(.all)
                .alert(isPresented: $alert, content: {
                    return Alert(title: Text(errorMessage))
                })
            }
            
            if showStamp {
                StampView(name: "Graffiti Pier")
                    .padding(.bottom, 100)
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                showStamp.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    showLounge.toggle()
                })
            })
          
        })

    }
    
    @ViewBuilder
    func mainImage(size: CGSize) -> some View {
            WebImage(url: URL(string: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fmaxresdefault.jpg?alt=media&token=c29d351b-b204-426d-a7f2-e71cba4396d3"))
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height * 3.5/4)
                .overlay {
                    customLayer()
                }
                .fullScreenCover(isPresented: $showLounge, content: {
                    Lounge()
                })
    }
    
    @ViewBuilder
    func titleView() -> some View {
        HStack(spacing: 0) {
            Image("dot person")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            
            Text("Graffiti Pier")
                .font(.system(size: 32))
                .foregroundStyle(.white)
                .fontWeight(.thin)
                .lineLimit(1)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.uturn.down.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white)
            })
        }
    }
    
    @ViewBuilder
    func customLayer() -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.linearGradient(
                    colors: [
                        .black.opacity(0.1),
                        .black.opacity(0.2),
                        .black
                    ],
                    startPoint: .top,
                    endPoint: .bottom))
    
                    titleView()
                        .padding(.bottom, 10)
                        .animation(.easeInOut(duration: 0.5), value: showInfo)
        }
    }
    
    @ViewBuilder
    func checkinButton() -> some View {
        Button(action: {
            showStamp.toggle()
           
        }, label: {
            Text("CHECK OUT")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundStyle(.black)
                .background(
                    Capsule()
                        .fill(.orange)
                        .frame(width: 180, height: 40)
                )
        })
        .padding(.bottom, 55)
    }
    
    
  
}

#Preview {
    LocationView()
}
