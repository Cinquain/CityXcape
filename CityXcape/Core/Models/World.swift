//
//  World.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation



struct World: Identifiable, Equatable, Codable {
    
    let id: String
    let name: String
    let imageUrl: String
        
    static func == (lhs: World, rhs: World) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl
    }
    
    init(data: [String: Any]) {
        self.id = data[World.CodingKeys.id.rawValue] as? String ?? ""
        self.name = data[World.CodingKeys.name.rawValue] as? String ?? ""
        self.imageUrl = data[World.CodingKeys.imageUrl.rawValue] as? String ?? ""
    }
    
    static let data = [
        World.CodingKeys.id.rawValue: "1KgaAMEDoqdNNZv6IQnH",
        World.CodingKeys.name.rawValue: "Artsy",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Fartsy%2FArtsy.png?alt=media&token=470f6281-c57c-4c73-87a2-1c848f2ec544"
    ]
    
    static let demo = World(data: data)
    
}
