//
//  User.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import Foundation


struct User: Identifiable, Equatable, Codable {
    
    let id: String
    let username: String
    let imageUrl: String
    let gender: Bool
    let city: String
    let streetcred: Int
    let worlds: [String]
    let fcmToken: String
 
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case imageUrl
        case gender
        case city
        case streetcred
        case worlds
        case fcmToken
    }
    
    init(id: String, username: String, imageUrl: String, gender: Bool, city: String, streetcred: Int, worlds: [String], fcmToken: String) {
        self.id = id
        self.username = username
        self.imageUrl = imageUrl
        self.gender = gender
        self.city = city
        self.streetcred = streetcred
        self.worlds = worlds
        self.fcmToken = fcmToken
    }
    
    init(data: [String: Any]?) {
        self.id = data?[User.CodingKeys.id.rawValue] as? String ?? ""
        self.username = data?[User.CodingKeys.username.rawValue] as? String ?? ""
        self.imageUrl = data?[User.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.gender = data?[User.CodingKeys.gender.rawValue] as? Bool ?? false
        self.city = data?[User.CodingKeys.city.rawValue] as? String ?? ""
        self.streetcred = data?[User.CodingKeys.streetcred.rawValue] as? Int ?? 0
        self.fcmToken = data?[User.CodingKeys.fcmToken.rawValue] as? String ?? ""
        self.worlds =  data?[User.CodingKeys.worlds.rawValue] as? [String] ?? []
    }
    
    static let data: [String: Any] = [
        User.CodingKeys.id.rawValue: "PlMt3eOkyseQIG9VDct6",
        User.CodingKeys.username.rawValue: "Alisha",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c",
        User.CodingKeys.gender.rawValue: false,
        User.CodingKeys.city.rawValue: "Minneapolis",
        User.CodingKeys.streetcred.rawValue: 100,
        User.CodingKeys.worlds.rawValue: [World.demo.id, World.demo2.id, World.demo3.id],
        User.CodingKeys.fcmToken.rawValue: "fkjfjjfgkjjg"
    ]
    
    static let data2: [String: Any] = [
        User.CodingKeys.id.rawValue: "orjoifhohd984308240984098uihffo",
        User.CodingKeys.username.rawValue: "Adam",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2Fman.png?alt=media&token=7b2a24de-49ce-4d40-a9a6-26325ee45371",
        User.CodingKeys.gender.rawValue: false,
        User.CodingKeys.city.rawValue: "Minneapolis",
        User.CodingKeys.streetcred.rawValue: 100,
        User.CodingKeys.worlds.rawValue: [World.demo4.id, World.demo5.id, World.demo6.id],
        User.CodingKeys.fcmToken.rawValue: "fkjfjjfgkjjg"
    ]
    
    static let data3: [String: Any] = [
        User.CodingKeys.id.rawValue: "orjoif83797947hohduihffo",
        User.CodingKeys.username.rawValue: "Ciara",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FCiara%20copy.png?alt=media&token=1a10681a-139a-4be7-9ab5-a71ef907bf10",
        User.CodingKeys.gender.rawValue: false,
        User.CodingKeys.city.rawValue: "Minneapolis",
        User.CodingKeys.streetcred.rawValue: 100,
        User.CodingKeys.worlds.rawValue: [World.demo3.id, World.demo.id, World.demo.id],
        User.CodingKeys.fcmToken.rawValue: "fkjfjjfgkjjg"
    ]
    
    static let demo = User(data: data)
    static let demo2 = User(data: data2)
    static let demo3 = User(data: data3)
}
