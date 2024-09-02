//
//  PassportPage.swift
//  CityXcape
//
//  Created by James Allan on 8/3/24.
//

import SwiftUI

struct PassportPage: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showPage: Bool = false
    
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 180))
    ]
    
    var body: some View {
        VStack {
            header()
            Spacer()
                .frame(height: 40)
            scrollView()
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .background(background())
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            SelfieBubble(size: 50, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FIMG_1575.png?alt=media&token=100ea308-bcb1-41cf-b53e-dc663a3f6692", pulse: 2)
            
            VStack(alignment: .leading) {
                
                Text("My Passport")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text("10 Locations")
                    .fontWeight(.semibold)
                    .font(.caption)
                
            }
            .foregroundStyle(.white)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.uturn.down.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .foregroundStyle(.white)
            })
           
        }
        .padding(.top, 50)
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("travel")
                .resizable()
                .scaledToFit()
                .opacity(0.4)
        }
        .edgesIgnoringSafeArea(.all)

    }
    
    @ViewBuilder
    func scrollView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(1..<11) { _ in
                    Button(action: {
                        showPage.toggle()
                    }, label: {
                        PostalStamp(url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fmaxresdefault.jpg?alt=media&token=c29d351b-b204-426d-a7f2-e71cba4396d3")
                    })
                    .sheet(isPresented: $showPage, content: {
                        StampPage()
                            .presentationDetents([.height(480)])
                    })
                }
                
            }
            
        }
    }
}

#Preview {
    PassportPage()
}
