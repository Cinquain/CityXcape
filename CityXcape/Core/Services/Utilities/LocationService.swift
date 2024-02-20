//
//  LocationService.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    static let shared = LocationService()
    
    let manager = CLLocationManager()
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)

    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorizationStatus()
    }
    
    var city: String?
    var loadMessage: String {
        return UserDefaults.standard.value(forKey: AppUserDefaults.loadMessage)  as? String ?? "Loading"
    }
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    func checkAuthorizationStatus() {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            print("Updating location")
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location permission is restricted")
            break
        case .denied:
            manager.requestWhenInUseAuthorization()
            print("Location Permission is denied")
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {return}
        self.userLocation = firstLocation.coordinate
        
        if let userLocation {
            self.region = .init(center: userLocation, span: span)
        }
        
        if let city = userLocation?.getCity() {
            let message = "Loading \(city)"
            print("The city is:", city)
            self.city = city
            UserDefaults.standard.set(message, forKey: AppUserDefaults.loadMessage)
            UserDefaults.standard.set(city, forKey: AppUserDefaults.city)
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
        if status == .restricted || status == .denied || status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    
}
