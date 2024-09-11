//
//  Lounge.swift
//  CityXcape
//
//  Created by James Allan on 8/12/24.
//

import SwiftUI

struct DigitalLounge: View {
    @AppStorage(CXUserDefaults.createdSP) var createdSP: Bool?
    @Environment(\.dismiss) private var dismiss
    
    @State private var showSP: Bool = false
    @State private var isShimmering: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showOnboarding: Bool = false
    
    var body: some View {
        VStack {
            header()
            guestList()
            Spacer()
        }
        .background(background())
        .edgesIgnoringSafeArea(.bottom)
     
    }
    
    @ViewBuilder
    func header() -> some View {
        VStack {
            HStack {
                Image("honeycomb")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                
                Text("Digital Lounge")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
                    .alert(isPresented: $showError, content: {
                        Alert(title: Text(errorMessage),
                              primaryButton: .default(Text("Ok"), action: {
                            showOnboarding.toggle()
                        }),
                        secondaryButton: .cancel()
                        )
                    })
                
                Spacer()
                
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.uturn.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(.white)
                        .fullScreenCover(isPresented: $showOnboarding, content: {
                            Onboarding()
                        })
                })
            }
            .padding(.horizontal, 10)
            
            Divider()
                .background(.white)
                .frame(height: 1)
                .padding(.horizontal, 10)
        }
    }
    
    @ViewBuilder
    func guestList() -> some View {
        ScrollView {
            ForEach(1..<30) { num in
              userRow()
            }
        }
        .padding(.top, 40)
        .fullScreenCover(isPresented: $showSP, content: {
            PublicStreetPass()
        })
    }
    
    @ViewBuilder
    func userRow() -> some View {
        HStack(spacing: 30) {
           
            Button(action: {
                showSP.toggle()
            }, label: {
                VStack(spacing: 2) {
                    UserDot(size: 100, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c")
                    Text("Alison")
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .font(.title3)
                }
            })
            
            
            VStack(alignment: .leading) {
                Text("Looking for Friends")
                    .fontWeight(.thin)
                Text("Checked in at 3:45")
                    .fontWeight(.thin)
                Divider()
                    .background(.white)
                    .frame(height: 0.5)
            }
            .foregroundStyle(.white)

          
            
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("honeycomb-blue")
                .resizable()
                .scaledToFill()
                .opacity(0.15)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    DigitalLounge()
}
