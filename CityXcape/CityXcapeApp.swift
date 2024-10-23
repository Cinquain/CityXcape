//
//  CityXcapeApp.swift
//  CityXcape
//
//  Created by James Allan on 7/31/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn




class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
    
   
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}


@main
struct CityXcapeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showLaunchView: Bool = true
    @ObservedObject var store = Store()
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                ContentView()
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
