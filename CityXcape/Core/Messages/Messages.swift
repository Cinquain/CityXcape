//
//  MessagesView.swift
//  CityXcape
//
//  Created by James Allan on 9/16/24.
//

import SwiftUI

struct Messages: View {
    
    @EnvironmentObject var vm: ChatViewModel
    @State var currentMessage : Message?
    
    var body: some View {
        
            VStack {
                header()
                ScrollView {
                    ForEach(vm.recents) { message in
                       
                        Button {
                            vm.messages = []
                            currentMessage = message
                        } label: {
                            ChatPreview(message: message)
                        }
                        .sheet(item: $currentMessage) { message in
                            Chatroom(message: message, vm: vm)
                        }

                    }
                }
                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear(perform: {
                vm.fetchRecentMessages()
            })
            .overlay(content: {
                if vm.recents.isEmpty {
                    emptyState()
                }
            })
            .toolbar(.visible, for: .tabBar)
            .background(HexBackground())
           

    }
    
    
    @ViewBuilder
    func header() -> some View {
            HStack(spacing: 5) {
                Spacer()
                Image(systemName: "message.fill")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.white.opacity(0.2))
                    .clipShape(Circle())
                
                Text("MESSAGES")
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .tracking(3)
                Spacer()
            }
            .padding(.bottom, 10)
         
    }
    
    @ViewBuilder
    func emptyState() -> some View {
        ContentUnavailableView(
            "No Conversations",
            systemImage: "message.circle.fill",
            description: Text("You don't have any messages")
        )
        .foregroundStyle(.white)
        .font(.title)
    }
    
}

#Preview {
    Messages()
        .environmentObject(ChatViewModel())
}
