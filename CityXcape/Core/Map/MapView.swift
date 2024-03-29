//
//  Map.swift
//  CityXcape
//
//  Created by James Allan on 8/24/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var vm: MapViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            MapViewRepresentable(viewModel: vm)
                .colorScheme(.dark)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                SearchField()
                  
                
                SearchResultView()
                    .fullScreenCover(isPresented: $vm.showCongrats) {
                        CongratsView(vm: vm)
                    }
                
                Spacer()
                    .frame(height: vm.keyboardHeight)
            }

        }

    }
    
    
    @ViewBuilder
    func SearchField() -> some View {
        HStack {
            TextField(vm.placeHolder, text: $vm.searchQuery, onCommit: {
                UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.endEditing(true)
                vm.performSearch()
            })
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(3)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                
        }
    }
    
    @ViewBuilder
    func SearchResultView() -> some View {
        ScrollView(.vertical) {
            VStack(spacing: 14) {
                ForEach(vm.mapItems, id: \.self) { mapItem in
                    
                    Button {
                        vm.selectedMapItem = mapItem
                        vm.spotName = mapItem.name ?? ""
                        vm.longitude = mapItem.placemark.coordinate.longitude
                        vm.latitude = mapItem.placemark.coordinate.latitude
                        vm.address = mapItem.getAddress()
                        vm.showForm.toggle()
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(mapItem.name ?? "Unknown Location")
                                .font(.headline)
                            Text(mapItem.placemark.title ?? mapItem.getAddress())
                                .lineLimit(1)
                                .font(.caption)
                            Text("Tap to create location")
                        }
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.black.opacity(0.8))
                    .cornerRadius(8)
                    .fullScreenCover(isPresented: $vm.showForm) {
                        PostForm(vm: vm)
                    }
               

                    //End of ForEach
                }
                //End of VStack
            }
            //Scrollview
        }
    }
       
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        MapView(vm: MapViewModel())
    }
}
