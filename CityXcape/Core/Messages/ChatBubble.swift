//
//  ChatBubble.swift
//  CityXcape
//
//  Created by James Allan on 9/16/24.
//

import SwiftUI
import FirebaseAuth

struct ChatBubble: View {
    
    var message: Message
    
    var body: some View {
        
        if isUser() {
            HStack {
                Spacer()
                HStack {
                    Text(message.content)
                        .foregroundStyle(.blue)
                }
                .padding()
                .background(.white)
                .cornerRadius(8)
            }
        } else {
            HStack {
                HStack {
                    Text(message.content)
                        .foregroundStyle(.white)
                }
                .padding()
                .background(.blue)
                .cornerRadius(8)
                Spacer()
            }
            .padding(10)
        }
       
    }
    
    
    fileprivate func isUser() -> Bool {
        if message.fromId == Auth.auth().currentUser?.uid ?? "ljhdhfkjhfhbdbbj" {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    ChatBubble(message: Message.demo)
}
