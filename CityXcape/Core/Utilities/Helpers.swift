//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/1/24.
//

import Foundation


enum UserType {
    case stranger
    case personal
}

struct CXUserDefaults {
    static let uid = "uid"
    static let firstOpen = "firstOpen"
    static let createdSP = "createdSP"
    static let profileUrl = "profileUrl"
    static let username = "username"
}

struct Server {
    static let users = "users"
    static let locations = "locations"
    static let world = "worlds"
    static let messages = "messgaes"
    static let connections = "connections"
    static let stamps = "stamps"
    static let recentMessage = "recentMessage"
    static let request = "requests"
}

enum Tab: String, CaseIterable {
    case locations = "Location"
    case profile = "Profile"
    case connections = "Requests"
    case messages = "Messages"
    
    var imageTitle: String {
        switch self {
        case .locations:
            return "location.circle.fill"
        case .connections:
            return "point.3.connected.trianglepath.dotted"
        case .profile:
            return "person.fill"
        case .messages:
            return "message.fill"
        }
    }
}

enum Orientation: String, CaseIterable, Identifiable, Codable {
    var id: Self { return self }
    
    case Bi
    case Straight
    case Gay
}

enum CustomError: Error {
    case authFailure
    case uidNotFound
    case failedPurchase
    case badUrl
    case badCompression
}

enum ImageCase {
    case profile
    case location
    case stamp
}

enum Keys: String {
    case proxy
}


