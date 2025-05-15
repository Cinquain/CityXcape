//
//  ContentView.swift
//  CityXcape
//
//  Created by James Allan on 7/31/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var store: Store
    @State var index: Int = 0
    @EnvironmentObject var connectionVM: ConnectionsVM
    @EnvironmentObject var chatVM: ChatViewModel


    
    var body: some View {
    
            TabView(selection: $index) {
                
                Checkin()
                    .tag(0)
                    .tabItem {
                        Image(systemName: Tab.checkin.imageTitle)
                            .renderingMode(.template)
                            .scaledToFit()
                        Text(Tab.checkin.rawValue)
                    }
                
                Connections(index: $index)
                    .tag(1)
                    .tabItem {
                        Image(Tab.connections.imageTitle)
                            .renderingMode(.template)
                            .scaledToFit()
                        Text(Tab.connections.rawValue)
                    }
                    .badge(connectionVM.count)
                
                Messages()
                    .tag(2)
                    .tabItem {
                        Image(systemName: Tab.messages.imageTitle)
                            .renderingMode(.template)
                            .scaledToFit()
                        Text(Tab.messages.rawValue)
                    }
                    .badge(chatVM.count)
             
                
                StreetPass()
                    .tag(3)
                    .tabItem {
                        Image(Tab.profile.imageTitle)
                            .renderingMode(.template)
                        Text(Tab.profile.rawValue)
                    }
                
                
            }
            .colorScheme(.dark)
            .accentColor(.white)
        
    }
}

#Preview {
    HomeView()
}
