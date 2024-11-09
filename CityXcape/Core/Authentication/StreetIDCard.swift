//
//  StreetIDCard.swift
//  CityXcape
//
//  Created by James Allan on 10/1/24.
//

import SwiftUI
import SDWebImageSwiftUI
import PhotosUI

struct StreetIDCard: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject var vm: UploadViewModel
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            OnboardingHeader()
            userView()
            
            worldList()
            passport()
            Spacer()
            
    
            
            Button {
                Task {
                    do {
                        try await vm.submitStreetPass()
                        dismiss()
                    } catch {
                        errorMessage = error.localizedDescription
                        showError.toggle()
                    }
                }
            } label: {
                Text("Create StreetPass")
                    .fontWeight(.thin)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 40)
                    .background(.blue)
                    .clipShape(Capsule())
                    .photosPicker(isPresented: $vm.showPicker, selection: $vm.selectedImage, matching: .images)
            }

        }
        .background(SPBackground())
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach(vm.selectedWorlds) {
                WebImage(url: URL(string: $0.imageUrl))
                    .resizable()
                    .scaledToFit()
                    .colorInvert()
                    .frame(height: 55)
            }
        }
        .padding(.top, 25)
        
    }
    
    @ViewBuilder
    func passport() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                vm.showPassport.toggle()
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
                PassportPage(stamps: [])
            })
            
         
        }
        .padding(.top, 20)
        
    }
  
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            Button(action: {
                vm.showPicker.toggle()
            }, label: {
                    SelfieBubble(
                        size: 300,
                        url: vm.imageUrl,
                    pulse: 1.2)
            })
            
            
            VStack {
                Text(vm.username)
                    .font(.title)
                .fontWeight(.thin)
                
                Text("2 StreetCred")
                    .fontWeight(.thin)
                    .font(.callout)

            }
            .foregroundStyle(.white)

            
          
        }
    }
}

#Preview {
    StreetIDCard(vm: UploadViewModel())
}
