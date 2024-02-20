//
//  World.swift
//  CityXcape
//
//  Created by James Allan on 2/5/24.
//

import Foundation


struct World: Identifiable, Equatable, Codable {
    
    var id: String
    var name: String
    var path: String
    var coverUrl: String
    var symbolUrl: String
    
    var passcode: String
    var ownerId: String
    
    
    var spotCount: Int
    var memberCount: Int
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case path
        case passcode
        case coverUrl = "cover_url"
        case symbolUrl = "symbol_url"
        case ownerId = "owner_id"
        case spotCount = "spot_count"
        case memberCount = "member_count"
    }
    static func == (lhs: World, rhs: World) -> Bool {
                return lhs.id == rhs.id
            }
    
    init(data: [String: Any]) {
        self.id = data[World.CodingKeys.id.rawValue] as? String ?? ""
        self.name = data[World.CodingKeys.name.rawValue] as? String ?? ""
        self.path = data[World.CodingKeys.path.rawValue] as? String ?? ""
        self.passcode = data[World.CodingKeys.passcode.rawValue] as? String ?? ""
        self.ownerId = data[World.CodingKeys.ownerId.rawValue] as? String ?? ""
        self.coverUrl = data[World.CodingKeys.coverUrl.rawValue] as? String ?? ""
        self.symbolUrl = data[World.CodingKeys.symbolUrl.rawValue] as? String ?? ""
        self.spotCount = data[World.CodingKeys.spotCount.rawValue] as? Int ?? 0
        self.memberCount = data[World.CodingKeys.memberCount.rawValue] as? Int ?? 0
    }
    
    static let data: [String: Any] = [
        World.CodingKeys.id.rawValue: "84EGmKarmnP21T0H0E9X",
        World.CodingKeys.name.rawValue: "Scout",
        World.CodingKeys.path.rawValue: "scout",
        World.CodingKeys.passcode.rawValue: "7452",
        World.CodingKeys.ownerId.rawValue: "QF9X5uxrYESeg9YrhvkvJ1lmKYi2",
        World.CodingKeys.coverUrl.rawValue: "file:///Users/jamesallan/Downloads/Scout%20Background-min.png",
        World.CodingKeys.symbolUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Worlds%2FScout%2FScout%20Logo.png?alt=media&token=871712a5-4b51-4d8d-a3cf-014b43407553",
        World.CodingKeys.memberCount.rawValue: 100000,
        World.CodingKeys.spotCount.rawValue: 100
    ]
    
    static let demo = World(data: data)
}
