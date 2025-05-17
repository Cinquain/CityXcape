//
//  Discover.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import SwiftUI
import CodeScanner

struct Checkin: View {
    @AppStorage(CXUserDefaults.uid) var uid: String?
    
    @EnvironmentObject var vm: CheckinViewModel
    
    var body: some View {
        ZStack {
            VStack {
                headerView()
                Spacer()
               
                Button(action: {
                    vm.handleCheckin()
                }, label: {
                       qrCodeVisual()
                })
                .opacity(0.9)
                .sheet(isPresented: $vm.startScanner, content: {
                    CodeScannerView(codeTypes: [.qr], completion: vm.handleScan)
                })
                
                ctaButton()
                Spacer()
            }
            .background(HexBackground())
            .opacity(vm.showLounge ? 0 : 1)
            .animation(.easeIn, value: vm.showLounge)
            
            
            if vm.showLounge {
                if let spot = vm.socialHub {
                    withAnimation(.easeIn) {
                        DigitalLounge(spot: spot, vm: vm)
                    }
                }
            }
            //End of ZStack
        }
       
        //End of body
    }
    
    
    
   
    
    @ViewBuilder
    func ctaButton() -> some View {
        Button(action: {
            vm.handleCheckin()
        }, label: {
            HStack {
                Image(systemName: "qrcode")
                Text(CXStrings.checkin)
                    .font(.title3)
                    .fontWeight(.light)
            }
            .foregroundStyle(.black)
            .frame(width: 200, height: 40)
            .background(.orange)
            .clipShape(Capsule())
                
        })
        .fullScreenCover(item: $vm.scavengerHunt) { spot in
            ScavengerHunt(spot: spot, vm: vm)
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
            HStack(spacing: 2) {
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .padding(.leading, 5)
                
                Spacer()
                
                
            }
            .padding(.bottom, 7)
    }
    
    @ViewBuilder
    func qrCodeVisual() -> some View {
        VStack {
            Image(systemName: "qrcode")
                .resizable()
                .foregroundStyle(.white)
                .scaledToFit()
                .frame(height: 220)
                .fullScreenCover(isPresented: $vm.startOnboarding) {
                   Onboarding()
                }
              
            
            Text(CXStrings.scanQrCode)
                .font(.title3)
                .foregroundStyle(.white)
                .fontWeight(.thin)
                .alert(isPresented: $vm.showError, content: {
                    if vm.showOnboardAlert {
                        return Alert(title: Text("You need a profile to check-in"), primaryButton: .default(Text("Get One")){
                            vm.startOnboarding = true
                        } , secondaryButton: .cancel())
                    } else {
                        return Alert(title: Text(vm.errorMessage))
                    }
                })
        }
    }
}

#Preview {
    Checkin()
        .environmentObject(CheckinViewModel())
}
