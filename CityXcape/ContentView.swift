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
    @EnvironmentObject private var store: Store

    
    var body: some View {
    
            TabView(selection: $selection) {
                Discover()
                    .tag(0)
                    .tabItem {
                        Image(Tab.locations.imageTitle)
                            .renderingMode(.template)
                        Text(Tab.locations.rawValue)
                    }
                
                RequestView(index: $selection)
                    .tag(1)
                    .tabItem {
                        Image(Tab.connections.imageTitle)
                            .renderingMode(.template)
                            .scaledToFit()
                        Text(Tab.connections.rawValue)
                    }
                    .badge(1)
                
                MessagesView()
                    .tag(2)
                    .tabItem {
                        Image(systemName: Tab.messages.imageTitle)
                        Text(Tab.messages.rawValue)
                    }
                
                StreetPass()
                    .tag(3)
                    .tabItem {
                        Image(Tab.profile.imageTitle)
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
