//
//  Connection.swift
//  CityXcape
//
//  Created by James Allan on 8/17/24.
//

import Foundation



struct Connection: Identifiable {
    let id: String
    let user1Id: String
    let user2Id: String
    let locationId: String
    
    let longitude: Double
    let latitude: Double
    let timestamp: Date
}
