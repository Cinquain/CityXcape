//
//  Discover.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import SwiftUI

struct Discover: View {
    @State private var showPage: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            headerView()
            Spacer()
            //Global geometry reader
            GeometryReader { mainframe in
                ScrollView {
                    VStack(spacing: 15) {
                        
                        ForEach(0..<11) { _ in
                            
                            GeometryReader { item in
                           
                                Button(action: {
                                    showPage.toggle()
                                }, label: {
                                    SpotView()
                                })
                                .padding(.bottom, 10)
                                .scaleEffect(scaleValue(mainframe.frame(in: .global).minY, item.frame(in: .global).minY), anchor: .bottom)
                                .opacity(Double(scaleValue(mainframe.frame(in: .global).minY, item.frame(in: .global).minY)))
                                .fullScreenCover(isPresented: $showPage, content: {
                                    LocationView()
                                })
                                
                            }
                            .frame(height: 200)
                        }
                    }
                    
                }
                .padding(.top, 25)
                .refreshable {
                    //Fetch additional spots
                }
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func scaleValue(_ mainFrame: CGFloat, _ minY: CGFloat) -> CGFloat {
        withAnimation(.easeOut) {
            let scale = (minY - 25) / mainFrame
            if scale > 1 {
                return 1
            } else {
                return scale
            }
        }
    }
    
    @ViewBuilder
    func headerView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 2) {
                Image("dot person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35)
                
                Text("Find Places to Socialize")
                    .font(.callout)
                    .foregroundStyle(.white)
                    .fontWeight(.thin)
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
