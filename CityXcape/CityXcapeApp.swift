//
//  CityXcapeApp.swift
//  CityXcape
//
//  Created by James Allan on 7/31/24.
//

import SwiftUI
import Firebase
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import FirebaseMessaging



@main
struct CityXcapeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showLaunchView: Bool = true
    @ObservedObject var store = Store()
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                HomeView()
                    .environmentObject(store)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2)
            }
            
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    registerForNotification(appDelegate: application)
    return true
  }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for notification", deviceToken)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            if #available(iOS 14.0, *) {
                completionHandler([.list, .banner, .sound])
            } else {
                completionHandler(.alert)
            }
        }
   
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received Notification: \(userInfo)")
        completionHandler(.newData)
    }
    
    func registerForNotification(appDelegate: UIApplication) {
        appDelegate.registerForRemoteNotifications()
    }
    
    
    
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            DataService.shared.updateFcmToken(fcm: fcmToken)
        } else {
        }
    }
}



