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
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        if spot.isSocialHub {
            DigitalLounge()
        } else {
            ScavengerHunt(spot: spot)
        }
    }
  
}

#Preview {
    LocationView(spot: Location.demo)
}
