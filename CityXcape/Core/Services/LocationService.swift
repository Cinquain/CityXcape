//
//  LocationService.swift
//  CityXcape
//
//  Created by James Allan on 9/27/24.
//

import UIKit
import CoreLocation
import MapKit
import SwiftUI


class LocationService: NSObject, ObservableObject {
    
    static let shared = LocationService()
    
    let manager = CLLocationManager()
    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    @Published var annotations: [MKPointAnnotation]  = []
    
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @Published var userCoordinates: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
    @Published var city: String = ""
    
    
    func checkAuthorizationStatus() {
        switch manager.authorizationStatus {
            case .authorizedAlways:
            manager.startUpdatingLocation()
            getCity()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            getCity()
        @unknown default:
            break
        }
    }
    
    func getCity() {
        if let coordinates = userCoordinates {
            coordinates.getCity { placemark in
                let newCity = placemark?.locality ?? ""
                print("The new city is: \(newCity)")
                self.city = newCity
            }
        }
    }
    
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {return}
        self.userCoordinates = firstLocation.coordinate
        if annotations.isEmpty {
            let annotation = MKPointAnnotation()
            annotation.coordinate = firstLocation.coordinate
            annotations.append(annotation)
            return
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .restricted:
            manager.requestWhenInUseAuthorization()
        case .denied:
            manager.requestWhenInUseAuthorization()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}
