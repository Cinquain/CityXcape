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
    let worlds: [World]
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
    
    
    init(data: [String: Any]?) {
        self.id = data?[User.CodingKeys.id.rawValue] as? String ?? ""
        self.username = data?[User.CodingKeys.username.rawValue] as? String ?? ""
        self.imageUrl = data?[User.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.gender = data?[User.CodingKeys.gender.rawValue] as? Bool ?? false
        self.city = data?[User.CodingKeys.city.rawValue] as? String ?? ""
        self.fcmToken = data?[User.CodingKeys.fcmToken.rawValue] as? String ?? ""
        self.streetcred = data?[User.CodingKeys.streetcred.rawValue] as? Int ?? 0
        let data = data?[User.CodingKeys.worlds.rawValue] as? [String: [String: Any]] ?? [:]
        var fetchedWorlds : [World] = []
        for value in data.values {
            let world = World(data: value)
            fetchedWorlds.append(world)
        }
        self.worlds = fetchedWorlds
    }
    
    init(id: String, username: String, imageUrl: String, gender: Bool, city: String, streetcred: Int, worlds: [World], fcmToken: String) {
        self.id = id
        self.username = username
        self.imageUrl = imageUrl
        self.gender = gender
        self.city = city
        self.streetcred = streetcred
        self.worlds = worlds
        self.fcmToken = fcmToken
    }
    
    
}


















//MARK: STATIC DATA
extension User {
    static let data: [String: Any] = [
        User.CodingKeys.id.rawValue: "PlMt3eOkyseQIG9VDct6",
        User.CodingKeys.username.rawValue: "Erica",
        User.CodingKeys.imageUrl.rawValue: "le",
        User.CodingKeys.gender.rawValue: false,
        User.CodingKeys.city.rawValue: "Minneapolis",
        User.CodingKeys.fcmToken.rawValue: "",
        User.CodingKeys.streetcred.rawValue: 100,
        User.CodingKeys.worlds.rawValue: ["OHf9hK5OkVD8q9fmKkom": World.data, "diuhfhhgi": World.data2, "fjfjbhbf":World.data6]
    ]
    
    static let data2: [String: Any] = [
        User.CodingKeys.id.rawValue: "orjoifhohd984308240984098uihffo",
        User.CodingKeys.username.rawValue: "Adam",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FJAv8CbZcZDUKNQx0PeGusp8cINC2%2FprofileImage?alt=media&token=eb587fbc-3461-4060-b6fb-73c0d10b7749",
        User.CodingKeys.gender.rawValue: false,
        User.CodingKeys.city.rawValue: "Minneapolis",
        User.CodingKeys.streetcred.rawValue: 100,
        User.CodingKeys.fcmToken.rawValue: "",
        User.CodingKeys.worlds.rawValue: ["iohufhhf":World.data4, "dubvjnbwu": World.data5, "fiooufhj": World.data6],
    ]
    
    static let data3: [String: Any] = [
        User.CodingKeys.id.rawValue: "orjoif83797947hohduihffo",
        User.CodingKeys.username.rawValue: "James",
        User.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FzuCiRbMq8EXbQmzJwP92OjjVeBZ2%2FprofileImage?alt=media&token=462898db-8a12-4296-a132-77f362763dfa",
        User.CodingKeys.gender.rawValue: false,
        User.CodingKeys.city.rawValue: "Minneapolis",
        User.CodingKeys.fcmToken.rawValue: "",
        User.CodingKeys.streetcred.rawValue: 100,
        User.CodingKeys.worlds.rawValue: ["jfhfhfhfh": World.data3, "dhhfhhff": World.data2, "dfggfgf": World.data5],
    ]
    
    static let demo = User(data: data)
    static let demo2 = User(data: data2)
    static let demo3 = User(data: data3)
}
