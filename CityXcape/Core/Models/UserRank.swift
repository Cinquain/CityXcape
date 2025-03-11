//
//  UserRank.swift
//  CityXcape
//
//  Created by James Allan on 3/8/25.
//

import Foundation



struct UserRank: Identifiable, Equatable, Codable {
    
    let id: String
    let username: String
    let imageUrl: String
    let totalSales: Float
    let totalSpots: Int
    
    static func == (lhs: UserRank, rhs: UserRank) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case imageUrl
        case totalSales
        case totalSpots
    }
  
}











extension UserRank {
    static let demo = UserRank(id: "BRjH3puxwIZueyIqvlEn", username: "Jay", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FBRjH3puxwIZueyIqvlEn%2FJay.png?alt=media&token=7e0fec7d-9e99-4c1e-a8d6-e1303482f43e", totalSales: 8570, totalSpots: 5)
    
    static let demo2 = UserRank(id: "UNhNwNz7GaOeT0Av0l7IDVQ5lCZ2", username: "Cinquain", imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/cityxcape-70313.appspot.com/o/Users%2FUNhNwNz7GaOeT0Av0l7IDVQ5lCZ2%2FprofileImage?alt=media&token=17303196-f519-4806-9c1a-3287efa79de2", totalSales: 11000, totalSpots: 8)
    
    static let demo3 = UserRank(id: "EVTU961bfeCZBEBzrBL0", username: "Sandra", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FEVTU961bfeCZBEBzrBL0%2FSandra.png?alt=media&token=07058b02-642b-44e4-a0ef-3548b250787e", totalSales: 4758, totalSpots: 7)
    
    static let demo4 = UserRank(id: "vyTY4QkiN6Jz8ckE4hpo", username: "Sean", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FvyTY4QkiN6Jz8ckE4hpo%2FIMG_8214.png?alt=media&token=4cb4285e-944d-4a2f-a3a0-70659124c9d4", totalSales: 6483, totalSpots: 11)
    
    static let demo5 = UserRank(id: "NwE1WVJY83RcQw4tttAkZ0Vg53Y2", username: "Erica", imageUrl: "https://firebasestorage.googleapis.com:443/v0/b/cityxcape-70313.appspot.com/o/Users%2FNwE1WVJY83RcQw4tttAkZ0Vg53Y2%2FprofileImage?alt=media&token=f1a4fd4d-f255-46a3-9d9a-89e7500b9cd1", totalSales: 3483, totalSpots: 12)
    
    static let ranks = [UserRank.demo, UserRank.demo2, UserRank.demo3, UserRank.demo4, UserRank.demo5]
}
