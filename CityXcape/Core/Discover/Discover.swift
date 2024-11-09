//
//  Discover.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import SwiftUI
import VisionKit
import CodeScanner

struct Discover: View {
    @AppStorage(CXUserDefaults.uid) var uid: String?
    @State private var showAlert: Bool = false
    @State private var startOnboarding: Bool = false
    @State private var scannedText: String = "Scan QR Code"
    @State private var startScanner: Bool = false
    @State private var currentSpot: Location?
    var body: some View {
        VStack {
            headerView()
            Spacer()
           
            Button(action: {
                startScanner.toggle()
            }, label: {
                VStack {
                    Image(systemName: "qrcode")
                        .resizable()
                        .foregroundStyle(.white)
                        .scaledToFit()
                        .frame(height: 220)
                    
                    Text(scannedText)
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .alert(isPresented: $showAlert, content: {
                            return Alert(title: Text("You need an account to check-in"), primaryButton: .default(Text("Ok")){
                                startOnboarding.toggle()
                            } , secondaryButton: .cancel())
                        })
                }
                   
            })
            .opacity(0.9)
            .sheet(isPresented: $startScanner, content: {
                CodeScannerView(codeTypes: [.qr], completion: handleScan)
            })
                
           
            
            ctaButton()
            Spacer()
        }
        .background(background())
        
    }
    
    fileprivate func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let code):
            startScanner = false 
            currentSpot = Location.demo
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("hex-background")
                .resizable()
                .scaledToFill()
                .opacity(0.3)
                .fullScreenCover(isPresented: $startOnboarding) {
                    Onboarding()
                }
              
        }
        .edgesIgnoringSafeArea(.all)

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
            startScanner.toggle()
        }, label: {
            Text("Check-In")
                .font(.title3)
                .foregroundStyle(.black)
                .fontWeight(.thin)
                .frame(width: 200, height: 40)
                .background(.orange)
                .clipShape(Capsule())
        })
        .fullScreenCover(item: $currentSpot) { spot in
            LocationView(spot: spot)
        }
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
