//
//  Location.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation
import CoreLocation


struct Location: Identifiable, Equatable, Codable {
    
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl
        case ownerId
        case worldId
        case longitude
        case latitude
        case timestamp
    }
}
