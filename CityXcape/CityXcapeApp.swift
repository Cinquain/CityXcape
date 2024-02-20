//
//  CityXcapeApp.swift
//  CityXcape
//
//  Created by James Allan on 8/8/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseMessaging

@main
struct CityXcapeApp: App {
    
    
    @State private var showLaunchView: Bool = true 
    @ObservedObject private var store = Store()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var vm = LocationsViewModel()
    let gpsManager = LocationService.shared
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                HomeView()
                    .environmentObject(vm)
                    .environmentObject(store)
                ZStack {
                    if showLaunchView {
                        LaunchView(message: gpsManager.loadMessage, showView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2)
                
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
  func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
    FirebaseApp.configure()
    registerForNotifications(app: application)
    return true
  }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Register for notifications", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Registered with FCM Token", fcmToken ?? "")
        if let fcmToken = fcmToken {
            DataService.shared.updateFcmToken(fcm: fcmToken)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.list, .banner, .sound])
        } else {
            completionHandler(.alert)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received Notification: \(userInfo)")
        completionHandler(.newData)
    }
    
    func registerForNotifications(app: UIApplication) {
        print("Registering for Push Notifications")
        Messaging.messaging().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Error getting notification permission", error.localizedDescription)
                return
            }
            
            if granted {
                print("Authorization granted!")
                UNUserNotificationCenter.current().delegate = self
            } else {
                print("Authorization request was denied")
            }
        }
        app.registerForRemoteNotifications()
    }
    
   
    
}

