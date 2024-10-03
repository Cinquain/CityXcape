//
//  User.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation


struct User: Identifiable, Equatable, Codable {
    
    let id: String
    let username: String
    let imageUrl: String
    let gender: Bool
    let city: String
    let streetcred: Int
    let worlds: [World]
    let timestamp: Date
    let fcmToken: String
 
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case imageUrl
        case gender
        case city
        case streetcred
        case worlds
        case timestamp
        case fcmToken
    }
    
}
