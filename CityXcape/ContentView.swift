//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 7/31/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage(CXUserDefaults.firstOpen) var firstOpen: Bool?
    @EnvironmentObject private var store: Store
    @State var index: Int = 0
    @StateObject var vm = LocationViewModel()

    
    var body: some View {
    
            TabView(selection: $index) {
                
                Discover(vm: vm)
                    .tag(0)
                    .tabItem {
                        Image(Tab.locations.imageTitle)
                            .renderingMode(.template)
                        Text(Tab.locations.rawValue)
                    }
                
                RequestView(vm: vm, index: $index)
                    .tag(1)
                    .tabItem {
                        Image(Tab.connections.imageTitle)
                            .renderingMode(.template)
                            .scaledToFit()
                        Text(Tab.connections.rawValue)
                    }
                    .badge(vm.requests.count)
                
                MessagesView(vm: vm)
                    .tag(2)
                    .tabItem {
                        Image(systemName: Tab.messages.imageTitle)
                            .renderingMode(.template)
                            .scaledToFit()
                        Text(Tab.messages.rawValue)
                    }
                    .badge(vm.count)
             
                
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
