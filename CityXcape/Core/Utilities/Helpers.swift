//
//  Helpers.swift
//  CityXcape
//
//  Created by James Allan on 8/1/24.
//

import Foundation
import SwiftUI





struct CXUserDefaults {
    static let uid = "uid"
    static let firstOpen = "firstOpen"
    static let createdSP = "createdSP"
    static let profileUrl = "profileUrl"
    static let username = "username"
    static let city = "city"
    static let streetcred = "streetcred"
    static let lastSpotId = "lastSpotId"
    static let lastSpotName = "lastSpotName"
    static let fcmToken = "fcmToken"
    static let isCheckedIn = "isCheckedIn"
}


struct CXStrings {
    static let dotPerson = "dot person"
    static let streetpass = "StreetPass"
    static let firstOne = "First One Here!"
    static let viewSP = "View Streetpass"
    static let waitMessage = "Please wait for more \n people to check in"
    static let loungeBackground = "chrome honey"
    static let checkin = "Check-In"
    static let checkout = "Check Out"
    static let scanQrCode = "Scan QR Code"
    static let privacyLink = "https://cityxcape.com/privacy_policy"
    static let termsLink = "https://cityxcape.com/terms.html"
    static let terms = "Terms & Conditions"
    static let privacy = "Privacy Policy"
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
    static let uploads = "uploads"
    static let expiresAt = "expiresAt"
    static let members = "members"
    static let userId = "userId"
    static let sale = "sale"
    static let sales = "sales"
    static let rankings = "rankings"
    static let commission = "commission"
}

enum Tab: String, CaseIterable {
    case checkin = "Check-In"
    case profile = "StreetPass"
    case connections = "Connections"
    case messages = "Messages"
    
    var imageTitle: String {
        switch self {
        case .checkin:
            return "qrcode.viewfinder"
        case .connections:
            return "hexagons-3"
        case .profile:
            return "idcard"
        case .messages:
            return "message.fill"
        }
    }
}

enum StreetCredUseCase: String, CaseIterable {
    case customStamp
    case connect
}



struct swipeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 128))
            .shadow(color: Color(UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)), radius: 12, x: 0, y: 0)
    }
}

enum Product: String, CaseIterable, Identifiable {
    case streetcred = "com.cityXcape.CityXcape8.streetcred3"
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

enum LocationMetrics: String, CaseIterable, Identifiable {
    case Checkins
    case Sales
    case Connections
    
    var id: Self {
        return self
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


