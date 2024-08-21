//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 7/31/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(CXUserDefaults.firstOpen) var firstOpen: Bool?
    @State var selection: Int = 0
    
    var body: some View {
        if firstOpen == nil || firstOpen == true {
            StartScreen()
        } else {
            TabView(selection: $selection) {
                Discover()
                    .tag(0)
                    .tabItem {
                        Image(systemName: Tab.locations.imageTitle)
                        Text(Tab.locations.rawValue)
                    }
                
                StreetPass()
                    .tag(1)
                    .tabItem {
                        Image(systemName: Tab.profile.imageTitle)
                        Text(Tab.profile.rawValue)
                    }
                
                
            }
            .colorScheme(.dark)
            .accentColor(.white)
        }
    }
}

#Preview {
    ContentView()
}
