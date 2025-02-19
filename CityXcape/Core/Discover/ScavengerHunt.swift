//
//  ScavengerHunt.swift
//  CityXcape
//
//  Created by James Allan on 9/17/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ScavengerHunt: View {
    @Environment(\.dismiss) private var dismiss

    var spot: Location
    @StateObject var vm: LocationViewModel

    @State private var showStamp: Bool = false
    @State private var showPreview: Bool = false
    @State private var showInfo: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader {
                let size = $0.size
                VStack(spacing: 10) {
                    mainImage(size: size)
                    Spacer()
                    showStampButton()
                }
                .background(.black)
                .edgesIgnoringSafeArea(.all)
                .alert(isPresented: $vm.showError, content: {
                    return Alert(title: Text(vm.errorMessage))
                })
            }
            
            if showStamp {
                StampView(name: spot.name, date: Date())
                    .padding(.bottom, 100)
            }
        }
        .onAppear(perform: {
          loadStamp()
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
                .sheet(isPresented: $showPreview, content: {
                    PassPortReceipt(spot: spot, vm: vm)
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
        }
    }
    
    @ViewBuilder
    func showStampButton() -> some View {
        Button(action: {
            showPreview.toggle()
        }, label: {
            Text("View Stamp")
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
    
    fileprivate func loadStamp() {
        vm.stampImageUrl = spot.imageUrl
        vm.createStamp(spot: spot)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            showStamp = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                showPreview = true
            })
        })
    }
    
}

#Preview {
    ScavengerHunt(spot: Location.demo, vm: LocationViewModel())
}
