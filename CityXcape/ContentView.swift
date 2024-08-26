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
    
            TabView(selection: $selection) {
                Discover()
                    .tag(0)
                    .tabItem {
                        Image(systemName: Tab.locations.imageTitle)
                        Text(Tab.locations.rawValue)
                    }
                
                RequestView()
                    .tag(1)
                    .tabItem {
                        Image(systemName: Tab.connections.imageTitle)
                        Text(Tab.connections.rawValue)
                    }
                    .badge(1)
                    
                
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

#Preview {
    ContentView()
}
