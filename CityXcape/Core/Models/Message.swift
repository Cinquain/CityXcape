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
    let imageUrl: String
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case fromId
        case toId
        case content
        case imageUrl
        case username
    }
    
    init(data: [String: Any]) {
        self.id = data[Message.CodingKeys.id.rawValue] as? String ?? ""
        self.fromId = data[Message.CodingKeys.fromId.rawValue] as? String ?? ""
        self.toId = data[Message.CodingKeys.toId.rawValue] as? String ?? ""
        self.content = data[Message.CodingKeys.content.rawValue] as? String ?? ""
        self.imageUrl = data[Message.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.username = data[Message.CodingKeys.username.rawValue] as? String ?? ""
    }
    
    static let data: [String: Any] = [
        Message.CodingKeys.id.rawValue: "ekjhuhshksfhf",
        Message.CodingKeys.fromId.rawValue: "kdhhfhfdoijofj",
        Message.CodingKeys.toId.rawValue: "dnkjbfkbkvjbbf",
        Message.CodingKeys.content.rawValue: "Hey handsome, wanna buy me a drink",
        Message.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c",
        Message.CodingKeys.username.rawValue: "Emilia"
    ]
    
    static let dataII: [String: Any] = [
        Message.CodingKeys.id.rawValue: "ekjhuhshksfhf",
        Message.CodingKeys.fromId.rawValue: "ljhdhfkjhfhbdbbj",
        Message.CodingKeys.toId.rawValue: "fhdoifhuhiuhih",
        Message.CodingKeys.content.rawValue: "Oh yeah... I got you",
        Message.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FIMG_1575.png?alt=media&token=100ea308-bcb1-41cf-b53e-dc663a3f6692",
        Message.CodingKeys.username.rawValue: "Cinquin"
    ]
    
    static let demo = Message(data: data)
    static let demoII = Message(data: dataII)
    
}
