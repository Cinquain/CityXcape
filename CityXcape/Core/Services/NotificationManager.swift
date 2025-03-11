//
//  NotificationManager.swift
//  CityXcape
//
//  Created by James Allan on 12/18/24.
//

import Foundation
import UserNotifications
import CoreLocation


final class NotificationManager: ObservableObject {
    
    static let shared = NotificationManager()
    private init() {}
    
    @Published var granted: Bool = false
    
    func requestAuthorization() {
        let options : UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Success getting notification permissions")
            }
            
            if success {
                self.granted = success
            }
            
        }
    }
    
    
    func scheduleGeoNotification(spot: Location) {
        let content = UNMutableNotificationContent()
        content.title = "Please checkout of \(spot.name)"
        content.subtitle = "CityXcape noticed you left the space"
        content.sound = .default
        content.badge = 1
        
        let coordinates = CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude)
        let region = CLCircularRegion(center: coordinates, radius: 100, identifier: UUID().uuidString)
        region.notifyOnEntry = false
        region.notifyOnExit = true
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func scheduleTimeNotification(spot: Location) {
        let content = UNMutableNotificationContent()
        content.title = "Are you still at \(spot.name)?"
        content.subtitle = "Please check out if you have left"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 7200, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    
    
}
