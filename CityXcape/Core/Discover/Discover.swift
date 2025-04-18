//
//  Discover.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import SwiftUI
import CodeScanner

struct Discover: View {
    @AppStorage(CXUserDefaults.uid) var uid: String?
    @State private var startOnboarding: Bool = false
    @State private var scannedText: String = "Scan QR Code"
    @State private var startScanner: Bool = false
    
    @StateObject var vm = LocationViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                headerView()
                Spacer()
               
                Button(action: {
                    handleCheckin()
                }, label: {
                       qrCodeVisual()
                })
                .opacity(0.9)
                .sheet(isPresented: $startScanner, content: {
                    CodeScannerView(codeTypes: [.qr], completion: handleScan)
                })
                
                ctaButton()
                Spacer()
            }
            .background(HexBackground())
            .opacity(vm.showLounge ? 0 : 1)
            .animation(.easeIn, value: vm.showLounge)
            
            
            if vm.showLounge {
                if let spot = vm.socialHubSpot {
                    withAnimation(.easeIn) {
                        DigitalLounge(spot: spot, vm: vm)
                    }
                }
            }
            //End of ZStack
        }
       
        //End of body
    }
    
    fileprivate func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
        case .success(let scanned):
            startScanner = false
            let scannedText = scanned.string
            let code = "27dwRVATDnUYxRsK0XVn"
            Task {
                do {
                    let spot = try await vm.checkin(spotId: code)
                    if !spot.isSocialHub {
                        vm.huntSpot = spot
                        return
                    }
                    vm.socialHubSpot = spot

                    vm.showLounge.toggle()

                } catch {
                    print("Error fetching location", error.localizedDescription)
                    vm.errorMessage =  error.localizedDescription
                    vm.showError.toggle()
                }
            }
        case .failure(let error):
            vm.errorMessage =  error.localizedDescription
            vm.showError.toggle()
            print(error.localizedDescription)
        }
    }
    
    fileprivate func handleCheckin() {
        AnalyticService.shared.pressedCheckin()
        if AuthService.shared.uid == nil {
            vm.showOnboarding.toggle()
            vm.showError.toggle()
            return
        }
        startScanner.toggle()
    }
    
    @ViewBuilder
    func ctaButton() -> some View {
        Button(action: {
          handleCheckin()
        }, label: {
            HStack {
                Image(systemName: "bell.badge.fill")
                Text("Check-In")
                    .font(.title3)
                    .fontWeight(.thin)
            }
            .foregroundStyle(.black)
            .frame(width: 200, height: 40)
            .background(.orange)
            .clipShape(Capsule())
                
        })
        .fullScreenCover(item: $vm.huntSpot) { spot in
            ScavengerHunt(spot: spot, vm: vm)
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 2) {
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
                    .padding(.leading, 5)
                
                Spacer()
                
                
            }
            .padding(.bottom, 7)
            
            Divider()
                .background(.white)
                .frame(height: 0.3)
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func qrCodeVisual() -> some View {
        VStack {
            Image(systemName: "qrcode")
                .resizable()
                .foregroundStyle(.white)
                .scaledToFit()
                .frame(height: 220)
                .fullScreenCover(isPresented: $startOnboarding) {
                   Onboarding()
                }
              
            
            Text(scannedText)
                .font(.title3)
                .foregroundStyle(.white)
                .fontWeight(.thin)
                .alert(isPresented: $vm.showError, content: {
                    if vm.showOnboarding {
                        return Alert(title: Text("You need an account to check-in"), primaryButton: .default(Text("Get One")){
                            startOnboarding = true
                        } , secondaryButton: .cancel())
                    } else {
                        return Alert(title: Text(vm.errorMessage))
                    }
                })
        }
    }
}

#Preview {
    Discover()
}
