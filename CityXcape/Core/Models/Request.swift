//
//  Request.swift
//  CityXcape
//
//  Created by James Allan on 8/15/24.
//

import Foundation



struct Request: Identifiable, Codable, Equatable {
    
    let id: String
    let username: String
    let ownerId: String
    let imageUrl: String
    let content: String
    let spotId: String
    
    
    init(id: String, username: String, ownerId: String, imageUrl: String, content: String, spotId: String) {
        self.id = id
        self.username = username
        self.ownerId = ownerId
        self.imageUrl = imageUrl
        self.content = content
        self.spotId = spotId
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case ownerId
        case imageUrl
        case content
        case spotId
    }
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    init(data: [String: Any]) {
        self.id = data[Request.CodingKeys.id.rawValue] as? String ?? ""
        self.username = data[Request.CodingKeys.username.rawValue] as? String ?? ""
        self.ownerId = data[Request.CodingKeys.ownerId.rawValue] as? String ?? ""
        self.imageUrl = data[Request.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.content = data[Request.CodingKeys.content.rawValue] as? String ?? ""
        self.spotId = data[Request.CodingKeys.spotId.rawValue] as? String ?? ""
    }
  
    
    static let demo = Request(id: "abc123", username: "Allison", ownerId: "dfhhhguhg", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c", content: "Hello handsome, want to buy me a drink", spotId: "abfhgitiejf")
    
    static let demo2 = Request(id: "abc1dldkkfn23", username: "Ciara", ownerId: "dfhhhguhfiooigojg", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FCiara%20copy.png?alt=media&token=1a10681a-139a-4be7-9ab5-a71ef907bf10", content: "Come to my table", spotId: "abfuygugghgitiejf")
    
}
