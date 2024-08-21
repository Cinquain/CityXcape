//
//  Request.swift
//  CityXcape
//
//  Created by James Allan on 8/15/24.
//

import Foundation



struct Request: Identifiable, Equatable {
    
    let id: String
    let username: String
    let ownerId: String
    let imageUrl: String
    let content: String
    let date: Date
    let read: Bool
    
    static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let demo = Request(id: "abc123", username: "Allison", ownerId: "dfhhhguhg", imageUrl: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c", content: "Hello handsome, want to buy me a drink", date: .now, read: false)
}
