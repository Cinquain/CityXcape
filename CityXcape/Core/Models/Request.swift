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
    let imageUrl: String
    let content: String
    let spotId: String
    let spotName: String
    let worlds: [String]
    
    
    init(id: String, username: String, imageUrl: String, content: String, spotId: String, spotName: String, worlds: [String]) {
        self.id = id
        self.username = username
        self.imageUrl = imageUrl
        self.content = content
        self.spotId = spotId
        self.spotName = spotName
        self.worlds = worlds
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case imageUrl
        case content
        case spotId
        case spotName
        case worlds
    }
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    init(data: [String: Any]) {
        self.id = data[Request.CodingKeys.id.rawValue] as? String ?? ""
        self.username = data[Request.CodingKeys.username.rawValue] as? String ?? ""
        self.imageUrl = data[Request.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.content = data[Request.CodingKeys.content.rawValue] as? String ?? ""
        self.spotId = data[Request.CodingKeys.spotId.rawValue] as? String ?? ""
        self.spotName = data[Request.CodingKeys.spotName.rawValue] as? String ?? ""
        self.worlds = data[Request.CodingKeys.worlds.rawValue] as? [String] ?? []
    }
  
    
    static let demo = Request(id: "abc123", username: "Allison", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c", content: "Hello handsome, want to buy me a drink", spotId: "abfhgitiejf", spotName: "Graffiti Pier", worlds: [World.demo3.id, World.demo.id, World.demo5.id])
    
    static let demo2 = Request(id: "abc1dldkkfn23", username: "Ciara", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FCiara%20copy.png?alt=media&token=1a10681a-139a-4be7-9ab5-a71ef907bf10", content: "Come to my table", spotId: "abfuygugghgitiejf", spotName: "Parlour Bar", worlds: [World.demo4.id, World.demo5.id, World.demo6.id])
    
    static let demo3 = Request(id: "abc1dlduwuhdhsdhjhdskkfn23", username: "Adam", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fman.png?alt=media&token=7b2a24de-49ce-4d40-a9a6-26325ee45371", content: "Where the weed @", spotId: "abfiuguuygugghgitiejf", spotName: "Hope Breakfast Bar", worlds: [World.demo.id, World.demo2.id, World.demo3.id])
    
    static let demo4 = Request(id: "dfijhfhghgkjgk3", username: "Larelle", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2F0t3mrKkN9Iaq0GiZJoTAHXgSNiq1%2Fblack%20girl.png?alt=media&token=ef9bc123-7bd1-4f1b-b9c7-e74d93ffeb2f", content: "Bring your friends to my table", spotId: "abfiuguuygugghgitiejf", spotName: "Four Seasons", worlds: [World.demo3.id, World.demo.id, World.demo2.id])
    
    
    static let demo5 = Request(id: "73747498584", username: "Amanda", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2F0t3mrKkN9Iaq0GiZJoTAHXgSNiq1%2FAmanda.png?alt=media&token=05909851-ebf9-47da-9c5a-5ea0670ed28a", content: "Let's get a drink", spotId: "abfiuguuygugghgitiejf", spotName: "Hope Breakfast Bar", worlds: [World.demo4.id, World.demo2.id, World.demo3.id])
    
    static let demo6 = Request(id: "abcdgguf1dlduwuhddhfhiuhfhsdhjhdskkfn23", username: "Sean", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FVAtXB9NvanVNjDN1rZoSTVWbd8G3%2FprofileImage?alt=media&token=1c928ade-f313-4da1-bbd7-90e645441ddb", content: "Let's split the price of a bottle", spotId: "abfiuguuygihsdihfugghgitiejf", spotName: "Devil's Advocate", worlds: [World.demo6.id, World.demo5.id, World.demo.id])
    
    

}
