//
//  Stamp.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation
import Firebase


struct Stamp: Identifiable, Equatable, Codable {
    
    let id: String
    let spotName: String
    let imageUrl: String
    let timestamp: Date
    let ownerId: String
    let spotId: String
    let city: String
    
    static func == (lhs: Stamp, rhs: Stamp) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case spotName
        case imageUrl
        case timestamp
        case ownerId
        case spotId
        case city
    }
    
    
    init(id: String, spotName: String, imageUrl: String, timestamp: Date, ownerId: String, spotId: String, city: String) {
        self.id = id
        self.spotName = spotName
        self.imageUrl = imageUrl
        self.timestamp = timestamp
        self.ownerId = ownerId
        self.spotId = spotId
        self.city = city
    }
    
    init(data: [String: Any]) {
        self.id = data[Stamp.CodingKeys.id.rawValue] as? String ?? ""
        self.spotName = data[Stamp.CodingKeys.spotName.rawValue] as? String ?? ""
        self.imageUrl = data[Stamp.CodingKeys.imageUrl.rawValue] as? String ?? ""
        let timestamp = data[Stamp.CodingKeys.timestamp.rawValue] as? Timestamp
        self.timestamp = timestamp?.dateValue() ?? Date()
        self.ownerId = data[Stamp.CodingKeys.ownerId.rawValue] as? String ?? ""
        self.spotId = data[Stamp.CodingKeys.spotId.rawValue] as? String ?? ""
        self.city = data[Stamp.CodingKeys.city.rawValue] as? String ?? ""
    }
    
    static let data: [String: Any] = [
        Stamp.CodingKeys.id.rawValue : "dkjfjgjgjkojojg",
        Stamp.CodingKeys.spotName.rawValue: "Graffiti Pier",
        Stamp.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fmaxresdefault.jpg?alt=media&token=c29d351b-b204-426d-a7f2-e71cba4396d3",
        Stamp.CodingKeys.timestamp.rawValue: Date(),
        Stamp.CodingKeys.ownerId.rawValue: "hfiguhhfj",
        Stamp.CodingKeys.spotId.rawValue: "ldinfnjnf",
        Stamp.CodingKeys.city.rawValue: "Philadelphia"
    ]
    
    static let data2: [String: Any] = [
        Stamp.CodingKeys.id.rawValue : "dkjf42398u938uejndfskmnsdjgjgjkojojg",
        Stamp.CodingKeys.spotName.rawValue: "The Vessel",
        Stamp.CodingKeys.imageUrl.rawValue: "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Hudson_Yards_Plaza_March_2019_53.jpg/2560px-Hudson_Yards_Plaza_March_2019_53.jpg",
        Stamp.CodingKeys.timestamp.rawValue: Date(),
        Stamp.CodingKeys.ownerId.rawValue: "hfiguhhfj",
        Stamp.CodingKeys.spotId.rawValue: "ldinfnjnf",
        Stamp.CodingKeys.city.rawValue: "New York"
    ]
    
    static let data3: [String: Any] = [
        Stamp.CodingKeys.id.rawValue : "dkjfjgjgjko899utiu44u3jojg",
        Stamp.CodingKeys.spotName.rawValue: "Eiffel Tower",
        Stamp.CodingKeys.imageUrl.rawValue: "https://media.architecturaldigest.com/photos/631f40a0b54052d450d2bc7c/16:9/w_2240,c_limit/GettyImages-627393180.jpg",
        Stamp.CodingKeys.timestamp.rawValue: Date(),
        Stamp.CodingKeys.ownerId.rawValue: "hfiguhhfj",
        Stamp.CodingKeys.spotId.rawValue: "ldinfnjnf",
        Stamp.CodingKeys.city.rawValue: "Paris"
    ]
    
    static let demo = Stamp(data: data)
    static let demoII = Stamp(data: data2)
    static let demoIII = Stamp(data: data3)
}
