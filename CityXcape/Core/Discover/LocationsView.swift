//
//  DiscoverView.swift
//  CityXcape
//
//  Created by James Allan on 8/24/23.
//

import SwiftUI

struct LocationsView: View {
    @EnvironmentObject private var vm: LocationsViewModel

    @State var currentSpot: Location?
   
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .zIndex(0)
            
            GeometryReader { mainView in
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(vm.locations) { location in
             
                            GeometryReader { item in
                                
                                SpotThumbnail(spot: location)
                                    .padding(.bottom, 10)
                                    .scaleEffect(scaleValue(mainView.frame(in: .global).minY, item.frame(in: .global).minY), anchor: .bottom)
                                    .opacity(Double(scaleValue(mainView.frame(in: .global).minY, item.frame(in: .global).minY)))
                                    .onTapGesture {
                                        currentSpot = location
                                    }

                                
                            }
                            .frame(height: 100)
                            .fullScreenCover(item: $currentSpot) { spot in
                                LocationView(spot: spot)
                            }
                           
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 25)
                }
                .zIndex(1)
                .refreshable {
                    vm.getAllLocations()
                }
            }
            
            
        }
        .task {
            vm.getAllLocations()
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
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack {
                Image("Logo White")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                
                Spacer()
                
               

            }
            
            Divider()
                .background(Color.white)
                .frame(height: 0.5)
           
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationsViewModel())
    }
}
