//
//  Connection.swift
//  CityXcape
//
//  Created by James Allan on 8/17/24.
//

import Foundation
import FirebaseFirestore



struct Connection: Identifiable, Codable {
    let id: String
    let user1Id: String
    let user2Id: String
    let spotId: String
    let timestamp: Timestamp
}
