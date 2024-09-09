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
}

enum Tab: String, CaseIterable {
    case locations = "Location"
    case profile = "Profile"
    case connections = "Requests"
    
    var imageTitle: String {
        switch self {
        case .locations:
            return "location.circle.fill"
        case .connections:
            return "point.3.connected.trianglepath.dotted"
        case .profile:
            return "person.fill"
        }
    }
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


