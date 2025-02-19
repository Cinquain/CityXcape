//
//  Location.swift
//  CityXcape
//
//  Created by James Allan on 8/7/24.
//

import SwiftUI
import CoreLocation
import CoreImage.CIFilterBuiltins


struct Location: Identifiable, Equatable, Codable {
    
    let id: String
    let name: String
    let imageUrl: String
    let ownerId: String
    let worldId: String
    
    let longitude: Double
    let latitude: Double
    let isSocialHub: Bool
    let city: String
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl
        case ownerId
        case isSocialHub
        case worldId
        case longitude
        case city
        case latitude
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
    
    func generateQRCode() -> UIImage? {
        filter.message = Data(id.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
    
    init(data: [String: Any]) {
        self.id = data[Location.CodingKeys.id.rawValue] as? String ?? ""
        self.name = data[Location.CodingKeys.name.rawValue] as? String ?? ""
        self.imageUrl = data[Location.CodingKeys.imageUrl.rawValue] as? String ?? ""
        self.ownerId = data[Location.CodingKeys.ownerId.rawValue] as? String ?? ""
        self.worldId = data[Location.CodingKeys.worldId.rawValue] as? String ?? ""
        self.longitude = data[Location.CodingKeys.id.rawValue] as? Double ?? 0
        self.latitude = data[Location.CodingKeys.latitude.rawValue] as? Double ?? 0
        self.isSocialHub = data[Location.CodingKeys.isSocialHub.rawValue] as? Bool ?? true
        self.city = data[Location.CodingKeys.city.rawValue] as? String ?? ""
    }
    
    
    static let data: [String: Any] = [
        Location.CodingKeys.id.rawValue: "abcxyz",
        Location.CodingKeys.name.rawValue: "Graffiti Pier",
        Location.CodingKeys.imageUrl.rawValue: "https://i.ytimg.com/vi/KM2rRv8b8aU/maxresdefault.jpg",
        Location.CodingKeys.ownerId.rawValue: "sdpojon",
        Location.CodingKeys.city.rawValue: "Philadelphia",
        Location.CodingKeys.worldId.rawValue: "oedfoijsdofjeofsd",
        Location.CodingKeys.isSocialHub.rawValue: false,
        Location.CodingKeys.longitude.rawValue: 13845556,
        Location.CodingKeys.latitude.rawValue: 8585988,
    ]
    
    
    static let demo = Location(data: data)
}
