//
//  MessagesView.swift
//  CityXcape
//
//  Created by James Allan on 9/16/24.
//

import SwiftUI

struct MessagesView: View {
    
    @StateObject var vm = ChatViewModel()
    var body: some View {
        NavigationView {
            VStack {
                header()
                ScrollView {
                    ForEach(vm.messages) { message in
                        NavigationLink {
                            Chatroom(uid: message.fromId, vm: vm)
                        } label: {
                            ChatPreview(message: message)
                        }

                    }
                }
            }
            .navigationBarHidden(true)
        }
        .colorScheme(.dark)
    }
    
    
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 5) {
            Spacer()
            Image("dot")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
            Text("MESSAGES")
                .fontWeight(.thin)
                .tracking(3)
            Spacer()
        }
        .padding(.bottom, 25)
    }
}

#Preview {
    MessagesView()
}
