//
//  BuySTC.swift
//  CityXcape
//
//  Created by James Allan on 8/14/24.
//

import SwiftUI

struct BuySTC: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var message: String = ""
    @State private var showError: Bool = false
    @State private var rotation: Double = 0
    @State var user: User
    
    @AppStorage(CXUserDefaults.streetcred) var wallet: Int?
    @EnvironmentObject private var store: Store

    var body: some View {
        VStack {
            headline()
            
            buttonRow()
            Spacer()
        }
        .cornerRadius(24)
        .background(background())
        .edgesIgnoringSafeArea(.bottom)
        .onAppear(perform: {
            withAnimation {
                rotation = 360
            }
            AnalyticService.shared.viewOrderPage()
        })
    }
    
    @ViewBuilder
    func background() -> some View {
        GeometryReader {
            let size = $0.size
            Image("network")
                .resizable()
                .scaledToFill()
                .overlay(Color.black.opacity(0.8))
                .frame(width: size.width, height: size.height)
                .edgesIgnoringSafeArea(.bottom)
                .alert(isPresented: $showError, content: {
                    return Alert(title: Text(message))
                })
        }
    }
    
    @ViewBuilder
    func headline() -> some View {
        VStack(spacing: 5) {
            Button(action: {
                dismiss()
            }, label: {
                Image("StreetCred")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: rotation))
                    .clipShape(Circle())
            })
            
            HStack {
                Spacer()
                VStack {
                    Text("Get StreetCred to Connect")
                        .fontWeight(.semibold)
                    
                    Text("1 STC Per Connection")
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .font(.caption)
                }
                Spacer()
            }
        }
        .padding(.bottom, 25)
        .foregroundStyle(.white)
    }
    
    @ViewBuilder
    func buttonRow() -> some View {
        VStack(spacing: 15) {
            Button(action: {
                if let product = store.product(for: Product.streetcred.rawValue) {
                    store.purchaseProduct(product) { result in
                        switch result {
                            case .success(_):
                            print("Successfully Bought StreetCred")
                            //Update Streetcred on backend
                            DataService.shared.purchaseStreetCred(count: Product.streetcred.count, price: 10, user: user)
                            AnalyticService.shared.ordered3STC()
                            case .failure(let error):
                            message = error.localizedDescription
                            showError.toggle()
                        }
                    }
                }
            }, label: {
                CoinCapsule(count: 3, price: 9.99)
            })
            
            Button(action: {
                if let product = store.product(for: Product.streetcred_15.rawValue) {
                    store.purchaseProduct(product) { result in
                        switch result {
                            case .success(_):
                            print("Successfully Bought StreetCred")
                            //Update Streetcred on backend
                            DataService.shared.purchaseStreetCred(count: Product.streetcred_15.count, price: 30, user: user)
                            AnalyticService.shared.ordered15STC()
                            case .failure(let error):
                            message = error.localizedDescription
                            showError.toggle()
                        }
                    }
                }
            }, label: {
                CoinCapsule(count: 15, price: 29.99)
            })
            
            Button(action: {
                if let product = store.product(for: Product.streetcred_50.rawValue) {
                    store.purchaseProduct(product) { result in
                        switch result {
                            case .success(_):
                            print("Successfully Bought StreetCred")
                            //Update Streetcred on backend
                            DataService.shared.purchaseStreetCred(count: Product.streetcred_50.count, price: 50, user: user)
                            AnalyticService.shared.ordered50STC()
                            case .failure(let error):
                            message = error.localizedDescription
                            showError.toggle()
                        }
                    }
                }
            }, label: {
                CoinCapsule(count: 50, price: 49.99)
            })
        }
        .padding(.bottom, 40)
    }
    
    
}

#Preview {
    BuySTC(user: User.demo)
}
