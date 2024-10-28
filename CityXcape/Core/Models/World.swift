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
    let memberName: String
    static func == (lhs: World, rhs: World) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl
        case memberName
    }
    
    init(data: [String: Any]) {
        self.id = data[World.CodingKeys.id.rawValue] as? String ?? ""
        self.name = data[World.CodingKeys.name.rawValue] as? String ?? ""
        self.imageUrl = data[World.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.memberName = data[World.CodingKeys.memberName.rawValue] as? String ?? ""
    }
    
    static let data = [
        World.CodingKeys.id.rawValue: "Z16DY5JPhBbIq15bG2LK",
        World.CodingKeys.name.rawValue: "Tech",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Ftech%2FTech.png?alt=media&token=15bfa6bb-9c5f-4d07-b0d0-8a3399035f51",
        World.CodingKeys.memberName.rawValue: "a Techy"
    ]
    
    static let data2 = [
        World.CodingKeys.id.rawValue: "gRFlwrdG3NUBxAlcuXYK",
        World.CodingKeys.name.rawValue: "Scout",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Fscout%2FScout.png?alt=media&token=5c46fe76-3367-4d69-b90b-95032d18539f",
        World.CodingKeys.memberName.rawValue: "a Scout"
    ]
    
    static let data3 = [
        World.CodingKeys.id.rawValue: "OHf9hK5OkVD8q9fmKkom",
        World.CodingKeys.name.rawValue: "Navy",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Fnavy%2FNavy.png?alt=media&token=c6d3123e-36fd-4c50-8dc9-61f0c7f29a59",
        World.CodingKeys.memberName.rawValue: "a Navy Vet"

    ]
    
    static let data4 = [
        World.CodingKeys.id.rawValue: "Z16DY5JPhBbiudhkjfhkhfkjhfIq15bG2LK",
        World.CodingKeys.name.rawValue: "Artsy",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Fartsy%2FArtsy.png?alt=media&token=470f6281-c57c-4c73-87a2-1c848f2ec544",
        World.CodingKeys.memberName.rawValue: "Artsy"

    ]
    
    static let data5 = [
        World.CodingKeys.id.rawValue: "gRFlwrdkjhkhdkhhfkjhfG3NUBxAlcuXYK",
        World.CodingKeys.name.rawValue: "Goth",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Fgoth%2FGoth.png?alt=media&token=2a5d61e0-7495-44f5-8dae-47434f05ccef",
        World.CodingKeys.memberName.rawValue: "Gothic"

    ]
    
    static let data6 = [
        World.CodingKeys.id.rawValue: "OHfffjhfgjfgjfg9hK5OkVD8q9fmKkom",
        World.CodingKeys.name.rawValue: "Entrepreneur",
        World.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Worlds%2Fentrepreneur%2FEntrepreneur.png?alt=media&token=d63a5ab0-827a-4375-99f4-a879e1d74327",
        World.CodingKeys.memberName.rawValue: "an Entrepreneur"

    ]
    
    static let demo = World(data: data)
    static let demo2 = World(data: data2)
    static let demo3 = World(data: data3)
    
    static let demo4 = World(data: data4)
    static let demo5 = World(data: data5)
    static let demo6 = World(data: data6)
    
}
