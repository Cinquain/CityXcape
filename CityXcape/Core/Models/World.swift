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
        World.CodingKeys.id.rawValue: "Z16DY5JPhBbIq15bG2LK",
        World.CodingKeys.name.rawValue: "Tech",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Ftech%2FTech.png?alt=media&token=971f389e-fec5-4f5b-a5cf-d3155557c6d7"
    ]
    
    static let data2 = [
        World.CodingKeys.id.rawValue: "gRFlwrdG3NUBxAlcuXYK",
        World.CodingKeys.name.rawValue: "Scout",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Fscout%2FScout.png?alt=media&token=36912bf1-995c-410b-b9ab-dc6b23d5c348"
    ]
    
    static let data3 = [
        World.CodingKeys.id.rawValue: "OHf9hK5OkVD8q9fmKkom",
        World.CodingKeys.name.rawValue: "Navy",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Fnavy%2FNavy.png?alt=media&token=c6d3123e-36fd-4c50-8dc9-61f0c7f29a59"
    ]
    
    static let demo = World(data: data)
    static let demo2 = World(data: data2)
    static let demo3 = World(data: data3)
    
}
