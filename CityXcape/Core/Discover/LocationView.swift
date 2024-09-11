//
//  LocationView.swift
//  CityXcape
//
//  Created by James Allan on 8/10/24.
//

import SwiftUI
import SDWebImageSwiftUI


struct LocationView: View {
    
    var spot: Location
    @Environment(\.dismiss) private var dismiss
    @AppStorage(CXUserDefaults.uid) var userId: String?

    
    @State private var showStamp: Bool = false
    @State private var showQRCode: Bool = false
    @State private var showPassport: Bool = false
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
                StampView(name: spot.name)
                    .padding(.bottom, 100)
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                showStamp = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    if spot.isSocialHub {
                        showLounge = true
                    } else {
                        showPassport.toggle()
                    }
                })
            })
          
        })

    }
    
    @ViewBuilder
    func mainImage(size: CGSize) -> some View {
        WebImage(url: URL(string: spot.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height * 3.5/4)
                .overlay {
                    customLayer()
                }
                .fullScreenCover(isPresented: $showLounge, content: {
                    DigitalLounge()
                })
    }
    
    @ViewBuilder
    func titleView() -> some View {
        HStack(spacing: 0) {
            Image("dot person")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            
            Text(spot.name)
                .font(.system(size: 32))
                .foregroundStyle(.white)
                .fontWeight(.thin)
                .lineLimit(1)
                .sheet(isPresented: $showPassport, content: {
                    PassPortReceipt()
                        .presentationDetents([.height(350)])
                })
            
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
                        .sheet(isPresented: $showQRCode, content: {
                            VStack {
                                Image(uiImage: spot.generateQRCode() ?? UIImage())
                                    .interpolation(.none)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 250)
                                
                                Button(action: saveToPhotosAlbum) {
                                    Text("Save QR Code")
                                        .font(.callout)
                                        .fontWeight(.thin)
                                        .foregroundStyle(.white)
                                        .frame(width: 160, height: 40)
                                        .background(.blue)
                                        .clipShape(Capsule())
                                }
                            }
                            .presentationDetents([.medium])
                        })
        }
    }
    
    @ViewBuilder
    func checkinButton() -> some View {
        Button(action: {
            showQRCode.toggle()
        }, label: {
            Text("Generate Code")
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
    
    fileprivate func saveToPhotosAlbum() {
        guard let image = spot.generateQRCode() else {return}
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    
  
}

#Preview {
    LocationView(spot: Location.demo)
}
