//
//  PassportPage.swift
//  CityXcape
//
//  Created by James Allan on 8/3/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct PassportPage: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showPage: Bool = false
    @State private var currentStamp: Stamp?
    @State var stamps: [Stamp]
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 180))
    ]
    
    var body: some View {
        ZStack {
            VStack {
                header()
                Spacer()
                    .frame(height: 40)
                if stamps.isEmpty {
                    EmptyState()
                } else {
                    scrollView()

                }
                Spacer()
            }
            .background(background())
            .edgesIgnoringSafeArea(.all)

            
            Color.black
                .opacity(showPage ? 0.95 : 0)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            
            
            VStack(alignment: .leading) {
                
                Text("My Passport")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text("\(stamps.count) Stamps")
                    .fontWeight(.semibold)
                    .font(.caption)
                
            }
            .foregroundStyle(.white)
         
            Spacer()
            
          
           
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
                .scaledToFill()
                .opacity(0.4)

        }

    }
    
    @ViewBuilder
    func scrollView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(stamps) { stamp in
                    Button(action: {
                        currentStamp = stamp
                    }, label: {
                        PostalStamp(stamp: stamp)
                    })
                    .sheet(item: $currentStamp) { stamp in
                        StampPage(stamp: stamp)
                            .presentationDetents([.height(480)])
                    }
                }
                
            }
            
        }
    }
    
    
    @ViewBuilder
    func EmptyState() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image("Eiffel Tower")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                Spacer()
            }
           
            Text("Check-in travel locations to \n get stamps on your passport")
                .font(.title3)
                .fontWeight(.thin)
                .multilineTextAlignment(.center)
            
            
            Spacer()
            Spacer()
            
            
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    PassportPage(stamps: [])
}
