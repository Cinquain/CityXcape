//
//  Location.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation
import CoreLocation


struct Location: Identifiable, Equatable {
    
    let id: String
    let name: String
    let imageUrl: String
    let ownerId: String
    let worldId: String
    
    let longitude: Double
    let latitude: Double
    let timestamp: Date

    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
