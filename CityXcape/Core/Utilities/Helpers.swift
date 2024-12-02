//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/1/24.
//

import Foundation
import SwiftUI



enum Names: String {
    case STREETPASS
}

struct CXUserDefaults {
    static let uid = "uid"
    static let firstOpen = "firstOpen"
    static let createdSP = "createdSP"
    static let profileUrl = "profileUrl"
    static let username = "username"
    static let streetcred = "streetcred"
    static let lastSpotId = "lastSpotId"
    static let lastSpotName = "lastSpotName"
    static let fcmToken = "fcmToken"
}

struct Server {
    static let users = "users"
    static let locations = "locations"
    static let world = "worlds"
    static let messages = "messages"
    static let connections = "connections"
    static let stamps = "stamps"
    static let recentMessage = "recentMessage"
    static let request = "requests"
    static let email = "email"
    static let checkins = "checkins"
    static let timestamp = "timestamp"
    static let fcmToken = "fcmToken"
    static let members = "members"
}

enum Tab: String, CaseIterable {
    case locations = "Check-In"
    case profile = "StreetPass"
    case connections = "Connections"
    case messages = "Messages"
    
    var imageTitle: String {
        switch self {
        case .locations:
            return "Checkin"
        case .connections:
            return "hexagons-3"
        case .profile:
            return "idcard"
        case .messages:
            return "message.fill"
        }
    }
}

struct swipeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 128))
            .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 12, x: 0, y: 0)
    }
}

enum Product: String, CaseIterable, Identifiable {
    case streetcred = "com.cityXcape.CityXcape8.streetcred"
    case streetcred_15 = "com.cityXcape.CityXcape8.streetcred15"
    case streetcred_50 = "com.cityXcape.CityXcape8.streetcred50"

    var id: Self { return self }
    
    var count: Int {
        switch self {
        case .streetcred:
            return 3
        case .streetcred_15:
            return 15
        case .streetcred_50:
            return 50
        }
    }
}

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .pressing, .inactive:
            return false
        case .dragging:
            return true
        }
    }
    
    var isPressing: Bool {
        switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
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


