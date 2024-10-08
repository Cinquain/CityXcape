//
//  Message.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation


struct Message: Identifiable, Codable {
    
    let id: String
    let fromId: String
    let toId: String
    let content: String
    let read: Bool
    let timestamp: Date
    
    let ownerImageUrl: String
    let displayName: String
    let spotName: String?
    let spotId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromId
        case toId
        case content
        case read
        case timestamp
        case ownerImageUrl
        case displayName
        case spotName
        case spotId
    }
    
    init(data: [String: Any]) {
        self.id = data[Message.CodingKeys.id.rawValue] as? String ?? ""
        self.fromId = data[Message.CodingKeys.fromId.rawValue] as? String ?? ""
        self.toId = data[Message.CodingKeys.toId.rawValue] as? String ?? ""
        self.content = data[Message.CodingKeys.content.rawValue] as? String ?? ""
        self.read = data[Message.CodingKeys.read.rawValue] as? Bool ?? false
        self.ownerImageUrl = data[Message.CodingKeys.ownerImageUrl.rawValue] as? String ?? ""
        self.displayName = data[Message.CodingKeys.displayName.rawValue] as? String ?? ""
        self.timestamp = data[Message.CodingKeys.timestamp.rawValue] as? Date ?? Date()
        self.spotName = data[Message.CodingKeys.spotName.rawValue] as? String ?? ""
        self.spotId = data[Message.CodingKeys.spotId.rawValue] as? String ?? ""
    }
    
    static let data: [String: Any] = [
        Message.CodingKeys.id.rawValue: "ekjhuhshksfhf",
        Message.CodingKeys.fromId.rawValue: "kdhhfhfdoijofj",
        Message.CodingKeys.toId.rawValue: "dnkjbfkbkvjbbf",
        Message.CodingKeys.content.rawValue: "Hey handsome, wanna buy me a drink",
        Message.CodingKeys.read.rawValue: true,
        Message.CodingKeys.timestamp.rawValue: Date(),
        Message.CodingKeys.spotName.rawValue: "Parlor Lounge",
        Message.CodingKeys.spotId.rawValue: "efehjehshso",
        Message.CodingKeys.ownerImageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c",
        Message.CodingKeys.displayName.rawValue: "Emilia"
    ]
    
    static let dataII: [String: Any] = [
        Message.CodingKeys.id.rawValue: "ekjhuhshksfhf",
        Message.CodingKeys.fromId.rawValue: "ljhdhfkjhfhbdbbj",
        Message.CodingKeys.toId.rawValue: "fhdoifhuhiuhih",
        Message.CodingKeys.content.rawValue: "Oh yeah... I got you",
        Message.CodingKeys.read.rawValue: true,
        Message.CodingKeys.spotId.rawValue: "efehjehshso",
        Message.CodingKeys.spotName.rawValue: "Up Down Arcade",
        Message.CodingKeys.timestamp.rawValue: Date(),
        Message.CodingKeys.ownerImageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FIMG_1575.png?alt=media&token=100ea308-bcb1-41cf-b53e-dc663a3f6692",
        Message.CodingKeys.displayName.rawValue: "Cinquin"
    ]
    
    static let demo = Message(data: data)
    static let demoII = Message(data: dataII)
    
}
