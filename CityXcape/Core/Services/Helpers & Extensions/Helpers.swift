//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation
import SwiftUI



struct Server {
    static let users = "users"
    static let worlds = "worlds"
    static let locations = "locations"
    static let privates = "users_private"
    static let checkIns = "checkins"
    static let saves = "saves"
    static let messages = "messages"
    static let stamps = "stamps"
    static let connections = "connections"
    static let recentMessages = "recentMessage"
    static let waves = "waves"
    static let likes = "likes"
    static let uploads = "uploads"
    static let requests = "requets"
    static let history = "history"
}

struct AppUserDefaults {
    static let uid = "uid"
    static let city = "city"
    static let bio = "bio"
    static let age = "age"
    static let streetcred = "streetcred"
    static let loadMessage = "loadMessage"
    static let profileUrl = "profileUrl"
    static let username = "username"
    static let location = "location"
    static let spotId = "spotId"
    static let fcmToken = "fcmtoken"
    static let createdSP = "createdStreetPass"
}

enum SpotOptions: String, CaseIterable, Identifiable {
    case showInfo
    case like
    case bookmark
    case checkin
    case dismiss
    case showMap
    case showOwner
    case none
    case gallery
    
    var id: Self {
        return self 
    }
}

enum Product: String, CaseIterable, Identifiable {
    case streetcred = "com.cityportal.CityXcape0.streetcred"
    case streetcred_50 = "com.cityportal.CityXcape0.streetcred50"
    case streetcred_100 = "com.cityportal.CityXcape0.streetcred100"
    var id: Product {self}
    
    var count:Int {
        switch self {
        case .streetcred:
            return 10
        case .streetcred_50:
            return 50
        case .streetcred_100:
            return 100
        }
    }
}

enum ImageCase {
    case one
    case two
    case three
}

enum PassType {
    case stranger
    case personal
}

enum CustomError: Error {
    case invalidPassword
    case uidNotFound
    case badData
    case failedPurchase
    case authFailed
}

enum MetricCategory: String, CaseIterable, Identifiable {
    case Views
    case Likes
    case Checkins
    var id: MetricCategory {self}
}

enum SpotMetric: String, CaseIterable, Identifiable {
    case Metrics
    case Modify
    var id: SpotMetric {self}
}


extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return NSLocalizedString("Incorrect Password", comment: "Invalid Password")
        case .uidNotFound:
            return NSLocalizedString("User AuthID Not Found", comment: "UID Not Found!")
        case .badData:
            return NSLocalizedString("Bad Data", comment: "Data not found or formatted incorrectly")
        case .failedPurchase:
            return NSLocalizedString("Failed Purchase", comment: "Purchase transaction did not go through")
        case .authFailed:
            return NSLocalizedString("Failed Authentication", comment: "Authentication did not go through")
        }
    }
}

enum Tab: String, CaseIterable {
    case locations = "tab2"
    case post = "mappin.square.fill"
    case profile = "person.text.rectangle.fill"
    case messages = "message.fill"
    case waves = "hive_feed"
    
    var title: String {
        switch self {
        case .locations:
            return "Locations"
        case .post:
            return "Post"
        case .profile:
            return "Profile"
        case .messages:
        return "Messages"
        case .waves:
            return "Connect"
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

enum Keys: String {
    case proxy
}

enum MyError: Error {
    case failedCompression(String)
}
