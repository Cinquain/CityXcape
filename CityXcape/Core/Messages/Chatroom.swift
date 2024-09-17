//
//  Chatroom.swift
//  CityXcape
//
//  Created by James Allan on 9/16/24.
//

import SwiftUI

struct Chatroom: View {
    @State private var message: String = ""
    var body: some View {
        ZStack {
            messages()
            
            VStack {
                Spacer()
                chatBar()
            }
        }
        .colorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                header()
            }
        }
    }
    
    
    @ViewBuilder
    func chatBar() -> some View {
        HStack {
            TextField("write your message", text: $message)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.black.opacity(0.8))
                .clipShape(Capsule())
            
            Spacer()
            
            Button {
                //Send message to chat branch
            } label: {
                Text("Send")
                    .foregroundStyle(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.blue)
            .cornerRadius(4)
        }
        .padding()
        .background(.black)
    }
    
    
    @ViewBuilder
    func messages() -> some View {
        ScrollView {
            ScrollViewReader { proxy in
                
                ForEach(1..<11) { num in
                    if num % 2 == 0 {
                        ChatBubble(message: Message.demoII)
                    } else {
                        ChatBubble(message: Message.demo)
                    }
                }
                
                HStack{Spacer()}
                    .id("proxy")
                    
            }
        }
        .background(.black)
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 2) {
            UserDot(size: 35, url: "https://firebasestorage.googleapis.com/v0/b/cityxcape-8888.appspot.com/o/Users%2FybA5qTaUH3OIMj1qPFACBRzbPnb2%2FAllison.png?alt=media&token=23e6eceb-b9b2-4a49-8b23-a11de0e2d32c")
            
            Text("Alicia")
                .foregroundStyle(.white)
                .fontWeight(.thin)
        }
    }
}

#Preview {
    NavigationView {
        Chatroom()
    }
}
