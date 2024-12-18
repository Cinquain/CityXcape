//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/2/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct StreetPass: View {
    
    @StateObject var vm : StreetPassViewModel
    var body: some View {
        VStack {
            header()
            userView()
            Spacer()
                .frame(maxHeight: 40)
            worldList()
            passport()
            Spacer()
        }
        .background(SPBackground())
    }
    
    

    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vm.user?.city ?? "")
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .tracking(4)
                    .alert(isPresented: $vm.showError, content: {
                        return Alert(title: Text(vm.errorMessage))
                    })
                
                Text(Names.STREETPASS.rawValue)
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .tracking(4)
                    .opacity(0.7)
                    .photosPicker(isPresented: $vm.showPicker, selection: $vm.selectedImage, matching: .images)
                
                
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
            ForEach(vm.user?.worlds ?? []) { world in
                Button {
                    Analytic.shared.viewedWorld()
                    vm.errorMessage = "You're part of the \(world.name) world"
                    vm.showError.toggle()
                } label: {
                    VStack {
                        WebImage(url: URL(string: world.imageUrl))
                            .resizable()
                            .scaledToFit()
                            .colorInvert()
                        .frame(height: 65)
                        Text(world.name)
                            .foregroundStyle(.white)
                            .fontWeight(.thin)
                            .lineLimit(1)
                            .font(.callout)
                            .frame(width: 55)

                    }
                }

            }
        }
        
    }
    
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            Button(action: {
                vm.showPicker.toggle()
            }, label: {
                    SelfieBubble(
                        size: 350,
                        url: vm.user?.imageUrl ?? "",
                    pulse: 1.2)
            })
            
            
            VStack {
                Text(vm.user?.username ?? "")
                    .font(.title)
                .fontWeight(.thin)
                
                Text("\(vm.user?.streetcred ?? 0) StreetCred")
                    .fontWeight(.thin)
                    .font(.callout)

            }
            .foregroundStyle(.white)

            
          
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func passport() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                vm.getStamps()
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
            .sheet(isPresented: $vm.showPassport, content: {
                PassportPage(stamps: vm.stamps)
            })
            
           
        }
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
    StreetPass(vm: StreetPassViewModel())
}
