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


