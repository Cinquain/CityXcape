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
    let worlds: [World]
    
    
    init(id: String, username: String, imageUrl: String, content: String, spotId: String, spotName: String, worlds: [World]) {
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
        let data = data[Request.CodingKeys.worlds.rawValue] as? [[String: Any]] ?? []
        var fetchedworlds: [World] = []
        for value in data {
            let world = World(data: value)
            fetchedworlds.append(world)
        }
        self.worlds = fetchedworlds
    }
  
    
    static let demo = Request(id: "abc123", username: "Allison", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FNwE1WVJY83RcQw4tttAkZ0Vg53Y2%2FprofileImage?alt=media&token=f1a4fd4d-f255-46a3-9d9a-89e7500b9cd1", content: "Hello handsome, want to buy me a drink", spotId: "abfhgitiejf", spotName: "Graffiti Pier", worlds: [World.demo3, World.demo, World.demo5])
    
    static let demo2 = Request(id: "abc1dldkkfn23", username: "Allan", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FJAv8CbZcZDUKNQx0PeGusp8cINC2%2FprofileImage?alt=media&token=eb587fbc-3461-4060-b6fb-73c0d10b7749", content: "Come to my table", spotId: "abfuygugghgitiejf", spotName: "Parlour Bar", worlds: [World.demo4, World.demo5, World.demo6])
    
    static let demo3 = Request(id: "abc1dlduwuhdhsdhjhdskkfn23", username: "James", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FJAv8CbZcZDUKNQx0PeGusp8cINC2%2FprofileImage?alt=media&token=eb587fbc-3461-4060-b6fb-73c0d10b7749", content: "dfbfjgjjgggggg", spotId: "fhjfjfjgggj", spotName: "Hope Breakfast Bar", worlds: [World.demo, World.demo2, World.demo3])
    
    
   
    
    

}
