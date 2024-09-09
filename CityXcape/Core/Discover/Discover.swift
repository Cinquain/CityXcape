//
//  Discover.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import SwiftUI
import VisionKit

struct Discover: View {
    @AppStorage(CXUserDefaults.uid) var uid: String?
    @State private var showPage: Bool = false
    @State private var showSignUp: Bool = false
    @State private var scannedText: String = "Tap to scan QR code"
    @State private var isShowingScanner: Bool = false
    var body: some View {
        VStack {
            headerView()
            Spacer()
           
            Image("qr-code")
                .resizable()
                .scaledToFit()
                .frame(height: 250)
                .sheet(isPresented: $isShowingScanner, content: {
                    DataScannerRepresentable(
                    shouldStartScanning: $isShowingScanner,
                    scannedText: $scannedText, 
                    dataToScanFor: [.barcode(symbologies: [.qr])])
                })
                
            Text(scannedText)
                .font(.title3)
                .foregroundStyle(.white)
                .fontWeight(.thin)
            ctaButton()
            Spacer()
        }
        .background(background())
        
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("black-paths")
                .renderingMode(.template)
                .foregroundStyle(.red)
                .scaledToFill()
                .fullScreenCover(isPresented: $showSignUp) {
                    SignUp()
                }
              
        }
    }
    
    @ViewBuilder
    func qrCode() -> some View {
        Image("QR Code")
            .resizable()
            .scaledToFit()
            .frame(height: 150)
            .opacity(0.5)
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
        Button(action: {
            isShowingScanner.toggle()
        }, label: {
            Text("scan")
                .font(.title3)
                .foregroundStyle(.black)
                .fontWeight(.thin)
                .frame(width: 200, height: 40)
                .background(.orange)
                .clipShape(Capsule())
        })
        .fullScreenCover(isPresented: $showPage, content: {
            LocationView()
        })
    }
    
    @ViewBuilder
        func headerView() -> some View {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 2) {
                    
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                    Spacer()
                    
                   
                }
                .padding(.bottom, 4)
                
                Divider()
                    .background(.white)
                    .frame(height: 0.5)
            }
            .padding(.horizontal, 10)
        }
}

#Preview {
    Discover()
}
