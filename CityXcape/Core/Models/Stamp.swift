//
//  Stamp.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation


struct Stamp: Identifiable, Equatable {
    
    let id: String
    let spotName: String
    let imageUrl: String
    let timestamp: Date
    let read: Bool
    let ownerId: String
    let spotId: String
    let city: String
    
    static func == (lhs: Stamp, rhs: Stamp) -> Bool {
        return lhs.id == rhs.id
    }
}
