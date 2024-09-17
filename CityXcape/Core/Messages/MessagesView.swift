//
//  MessagesView.swift
//  CityXcape
//
//  Created by James Allan on 9/16/24.
//

import SwiftUI

struct MessagesView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                header()
                ScrollView {
                    ForEach(1..<10) { _ in
                        NavigationLink {
                            Chatroom()
                        } label: {
                            ChatPreview(message: Message.demo)
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
