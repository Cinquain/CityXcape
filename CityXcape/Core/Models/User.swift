//
//  User.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation


struct User: Identifiable, Equatable {
    
    let id: String
    let username: String
    let imageUrl: String
    let goal: String
    let streetcred: Int
    let worldId: String
    let isMale: Bool
    let timestamp: Date
    let fcmToken: String?

 
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
}
