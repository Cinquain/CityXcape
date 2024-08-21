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
    case locations = "Locations"
    case profile = "Profile"
    
    var imageTitle: String {
        switch self {
        case .locations:
            return "location.circle.fill"
        case .profile:
            return "person.fill"
        }
    }
}


