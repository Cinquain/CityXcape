//
//  LocationView.swift
//  CityXcape
//
//  Created by James Allan on 8/10/24.
//

import SwiftUI
import SDWebImageSwiftUI


struct LocationView: View {
    
    var spot: Location
    @StateObject var vm = LocationViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if spot.isSocialHub {
            DigitalLounge(spot: spot, vm: vm)
        } else {
            ScavengerHunt(spot: spot, vm: vm)
        }
    }
  
}

#Preview {
    LocationView(spot: Location.demo)
}
