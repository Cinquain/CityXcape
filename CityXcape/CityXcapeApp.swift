//
//  CityXcapeApp.swift
//  CityXcape
//
//  Created by James Allan on 7/31/24.
//

import SwiftUI

@main
struct CityXcapeApp: App {
    @State private var showLaunchView: Bool = true
    
    var body: some Scene {
        WindowGroup {
            
            ZStack {
                ContentView()
                
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
