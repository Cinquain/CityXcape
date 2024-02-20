//
//  SecretSpot.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Location: Identifiable, Equatable, Codable, Hashable {
    
    //Basic Properities
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    let longitude: Double
    let latitude: Double
    let city: String
    let address: String?
    let timestamp: Date
    let ownerId: String
    let ownerImageUrl: String
    let ownerUsername: String
    let extraImages: [String]
    
    //Social Component
    let saveCount: Int
    let likeCount: Int
    let liveCount: Int
    let viewCount: Int
    let checkinCount: Int
    let commentCount: Int
    let connections: Int

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
            return lhs.id == rhs.id
        }
    
    var distanceString: String {
            let manager = LocationService.shared.manager
            
            if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
                let destination = CLLocation(latitude: latitude, longitude: longitude)
                let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude) ?? 0, longitude: (manager.location?.coordinate.longitude) ?? 0)
                let distance = userlocation.distance(from: destination)
                let distanceinMi =  distance * 0.000621
                let distanceinFt =  distance * 3.28084
                let roundedDistance = String(format: "%.0f", distanceinMi)
                let roundedDistanceMeters  = String(format: "%.2f", distanceinMi)
                if distanceinMi > 1 {
                    return "\(roundedDistance) mi"
                } else {
                    return "\(roundedDistanceMeters) mi"
                }
            } else {
                manager.requestWhenInUseAuthorization()
                return "N/A"
            }

        }
    
    var distanceFromUser: Double {
        let manager = LocationService.shared.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let destination = CLLocation(latitude: latitude, longitude: longitude)
            let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude) ?? 0, longitude: (manager.location?.coordinate.longitude) ?? 0)
            let distance = userlocation.distance(from: destination) * 3.28084
            return distance
        } else {
            manager.requestWhenInUseAuthorization()
            return 1000
        }
    }
    
    var distanceFromUserinMiles: Double {
        let manager = LocationService.shared.manager
        
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            let destination = CLLocation(latitude: latitude, longitude: longitude)
            let userlocation = CLLocation(latitude: (manager.location?.coordinate.latitude) ?? 0, longitude: (manager.location?.coordinate.longitude) ?? 0)
            let distance = userlocation.distance(from: destination) * 0.000621
            return distance
        } else {
            manager.requestWhenInUseAuthorization()
            return 1000
        }
    }
    
    
    
    init(data: [String: Any]) {
        self.id = data[Location.CodingKeys.id.rawValue] as? String ?? ""
        self.name = data[Location.CodingKeys.name.rawValue] as? String ?? ""
        self.description = data[Location.CodingKeys.description.rawValue] as? String ?? ""
        self.imageUrl = data[Location.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.latitude = data[Location.CodingKeys.latitude.rawValue] as? Double ?? 0
        self.longitude = data[Location.CodingKeys.longitude.rawValue] as? Double ?? 0
        self.city = data[Location.CodingKeys.city.rawValue] as? String ?? ""
        self.address = data[Location.CodingKeys.address.rawValue] as? String ?? ""
        let timestamp = data[Location.CodingKeys.timestamp.rawValue] as? Timestamp
        self.timestamp = timestamp?.dateValue() ?? Date()
        self.saveCount = data[Location.CodingKeys.saveCount.rawValue] as? Int ?? 1
        self.commentCount = data[Location.CodingKeys.commentCount.rawValue] as? Int ?? 0
        self.likeCount = data[Location.CodingKeys.likeCount.rawValue] as? Int ?? 0
        self.checkinCount = data[Location.CodingKeys.checkinCount.rawValue] as? Int ?? 0
        self.ownerId = data[Location.CodingKeys.ownerId.rawValue] as? String ?? ""
        self.connections = data[Location.CodingKeys.connections.rawValue] as? Int ?? 0
        self.viewCount = data[Location.CodingKeys.viewCount.rawValue] as? Int ?? 0
        self.liveCount = data[Location.CodingKeys.liveCount.rawValue] as? Int ?? 0
        self.ownerImageUrl = data[Location.CodingKeys.ownerImageUrl.rawValue] as? String ?? ""
        self.ownerUsername = data[Location.CodingKeys.ownerUsername.rawValue] as? String ?? ""
        self.extraImages = data[Location.CodingKeys.extraImages.rawValue] as? [String] ?? []
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageUrl
        case longitude
        case latitude
        case likeCount
        case city
        case timestamp
        case connections
        case address
        case liveCount
        case ownerId 
        case saveCount = "save_count"
        case checkinCount = "checkin_count"
        case commentCount = "comment_count"
        case viewCount = "view_count"
        case ownerImageUrl
        case ownerUsername
        case extraImages
    }
    
    static let data: [String: Any] = [
        Location.CodingKeys.id.rawValue: "uFAFkCFpvl39e85Q07Ez",
        Location.CodingKeys.name.rawValue: "Graffiti Pier",
        Location.CodingKeys.description.rawValue: "Graffiti Pier is a landmark in the street art scene, attracting graf writers and artists from clear across the eastern seaboard, proudly exhibiting why Philadelphia is a hotspot of cultural production. It’s also a place reflective of the culture of industry and the working class roots of Port Richmond and many Philadelphians. The 6-acre site is a place of mystique, offering a sense of discovery and adventure. It’s a place known, but unknown; familiar, but found. Graffiti Pier is a place that offers unique prospect over the river and a valuable space of reflection in the midst of everyday urban life.",
        Location.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FDdRzArPrhQvEKBJfppIe%2FExample.jpg?alt=media&token=718582c2-7b49-4585-b2d0-0c78ba51253f",
        Location.CodingKeys.city.rawValue: "Philadelphia",
        Location.CodingKeys.address.rawValue: "Philadelphia, PA 19125",
        Location.CodingKeys.latitude.rawValue: 39.971779951285704,
        Location.CodingKeys.longitude.rawValue: -75.1136488197242,
        Location.CodingKeys.timestamp.rawValue: Date(),
        Location.CodingKeys.likeCount.rawValue: 322,
        Location.CodingKeys.saveCount.rawValue: 100,
        Location.CodingKeys.checkinCount.rawValue: 34,
        Location.CodingKeys.commentCount.rawValue: 40,
        Location.CodingKeys.viewCount.rawValue: 423,
        Location.CodingKeys.ownerImageUrl.rawValue: "https://firebasestorage.googleapis.com:443/v0/b/cityxcape-8888.appspot.com/o/users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2FprofileImage?alt=media&token=aafa276b-f77c-48a5-901b-66d80c56023d",
        Location.CodingKeys.ownerUsername.rawValue: "Janelle"
    ]
    
    static let data1: [String: Any] = [
        Location.CodingKeys.id.rawValue: "uFAFkCF245pvl39e85Q07Ez",
        Location.CodingKeys.name.rawValue: "The Vessel",
        Location.CodingKeys.description.rawValue: "Graffiti Pier is a landmark in the street art scene, attracting graf writers and artists from clear across the eastern seaboard, proudly exhibiting why Philadelphia is a hotspot of cultural production. It’s also a place reflective of the culture of industry and the working class roots of Port Richmond and many Philadelphians. The 6-acre site is a place of mystique, offering a sense of discovery and adventure. It’s a place known, but unknown; familiar, but found. Graffiti Pier is a place that offers unique prospect over the river and a valuable space of reflection in the midst of everyday urban life.",
        Location.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FnS32I8rSz1Xly5IGwYPx%2Fpexels-alteredsnaps-12167671.jpg?alt=media&token=e8ad1850-30f5-42c8-88d3-100b98a5faef",
        Location.CodingKeys.city.rawValue: "New York",
        Location.CodingKeys.address.rawValue: "Philadelphia, PA 19125",
        Location.CodingKeys.latitude.rawValue: 39.971779951285704,
        Location.CodingKeys.longitude.rawValue: -75.1136488197242,
        Location.CodingKeys.timestamp.rawValue: Date(),
        Location.CodingKeys.likeCount.rawValue: 21,
        Location.CodingKeys.saveCount.rawValue: 10,
        Location.CodingKeys.checkinCount.rawValue: 3,
        Location.CodingKeys.commentCount.rawValue: 4,
        Location.CodingKeys.viewCount.rawValue: 1485,
        Location.CodingKeys.ownerImageUrl.rawValue: "https://firebasestorage.googleapis.com:443/v0/b/cityxcape-8888.appspot.com/o/users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2FprofileImage?alt=media&token=aafa276b-f77c-48a5-901b-66d80c56023d",
        Location.CodingKeys.ownerUsername.rawValue: "Janelle",
        Location.CodingKeys.extraImages.rawValue: ["https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/0b277eb6-0e2c-4b09-8a8e-67b44fbea63b/dfyn589-a836d5cf-8b40-49f9-a37f-88f4abcc4fdd.png/v1/fit/w_512,h_960,q_70,strp/blonde_woman_by_marcus199911_dfyn589-375w-2x.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9OTYwIiwicGF0aCI6IlwvZlwvMGIyNzdlYjYtMGUyYy00YjA5LThhOGUtNjdiNDRmYmVhNjNiXC9kZnluNTg5LWE4MzZkNWNmLThiNDAtNDlmOS1hMzdmLTg4ZjRhYmNjNGZkZC5wbmciLCJ3aWR0aCI6Ijw9NTEyIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.QbL-L-2hvZwA4cmPIOcxIcYraLvDQA5Hg4824dgMeXs","https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/228445e9-d455-4c04-9acb-e0a6f0601a7d/dfmdytk-81ace428-0a2a-4282-b06e-49d8de3e7cec.jpg/v1/fit/w_828,h_1242,q_70,strp/the_taste_of_transformation___tg_caption_by_c0vergirl_dfmdytk-414w-2x.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTUzNiIsInBhdGgiOiJcL2ZcLzIyODQ0NWU5LWQ0NTUtNGMwNC05YWNiLWUwYTZmMDYwMWE3ZFwvZGZtZHl0ay04MWFjZTQyOC0wYTJhLTQyODItYjA2ZS00OWQ4ZGUzZTdjZWMuanBnIiwid2lkdGgiOiI8PTEwMjQifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.G4raTQe2Tji2ys9wOuDjOgkenyGfa6erxrPNd3RLofQ",]
    ]
    
    static let data2: [String: Any] = [
        Location.CodingKeys.id.rawValue: "uFAFkCFpvl39e667785Q07Ez",
        Location.CodingKeys.name.rawValue: "One57 Bar",
        Location.CodingKeys.description.rawValue: "Graffiti Pier is a landmark in the street art scene, attracting graf writers and artists from clear across the eastern seaboard, proudly exhibiting why Philadelphia is a hotspot of cultural production. It’s also a place reflective of the culture of industry and the working class roots of Port Richmond and many Philadelphians. The 6-acre site is a place of mystique, offering a sense of discovery and adventure. It’s a place known, but unknown; familiar, but found. Graffiti Pier is a place that offers unique prospect over the river and a valuable space of reflection in the midst of everyday urban life.",
        Location.CodingKeys.imageUrl.rawValue: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Locations%2FuFAFkCFpvl39e85Q07Ez%2Fpexels-cottonbro-studio-4694309.jpg?alt=media&token=8ee09f94-bb69-4c72-9290-544737def64a",
        Location.CodingKeys.city.rawValue: "New York",
        Location.CodingKeys.address.rawValue: "Philadelphia, PA 19125",
        Location.CodingKeys.latitude.rawValue: 39.971779951285704,
        Location.CodingKeys.longitude.rawValue: -75.1136488197242,
        Location.CodingKeys.timestamp.rawValue: Date(),
        Location.CodingKeys.saveCount.rawValue: 10,
        Location.CodingKeys.likeCount.rawValue: 60,
        Location.CodingKeys.checkinCount.rawValue: 3,
        Location.CodingKeys.commentCount.rawValue: 4,
        Location.CodingKeys.viewCount.rawValue: 25485,
        Location.CodingKeys.ownerImageUrl.rawValue: "https://firebasestorage.googleapis.com:443/v0/b/cityxcape-8888.appspot.com/o/users%2FoVbS9qDAccXS0aqwHtWXvCYfGv62%2FprofileImage?alt=media&token=aafa276b-f77c-48a5-901b-66d80c56023d",
        Location.CodingKeys.ownerUsername.rawValue: "Janelle"
    ]
    
    static let demo = Location(data: data)
    static let demo1 = Location(data: data1)
    static let demo2 = Location(data: data2)
}
