//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 7/31/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(CXUserDefaults.firstOpen) var firstOpen: Bool?
    @State var index: Int = 0
    @StateObject var vm = RequestViewModel()
    @StateObject var sp = StreetPassViewModel()
    @StateObject var chatVm = ChatViewModel()
    @EnvironmentObject private var store: Store

    
    var body: some View {
    
            TabView(selection: $index) {
                Discover()
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
                
                MessagesView(vm: chatVm)
                    .tag(2)
                    .tabItem {
                        Image(systemName: Tab.messages.imageTitle)
                            .renderingMode(.template)
                            .scaledToFit()
                        Text(Tab.messages.rawValue)
                    }
                    .badge(chatVm.recents.count)
             
                
                StreetPass(vm: sp)
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
