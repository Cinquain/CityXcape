//
//  Chatroom.swift
//  CityXcape
//
//  Created by James Allan on 9/16/24.
//

import SwiftUI
import FirebaseFirestore
struct Chatroom: View {
    @Environment(\.dismiss) private var dismiss

    let message: Message
    @StateObject var vm : ChatViewModel 
    
    var body: some View {
        ZStack {
            VStack {
                header()
                messages()
            }
            
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
        .onAppear(perform: {
            vm.fetchMessageFor(uid: message.fromId)
        })
        .onDisappear(perform: {
            vm.removeChatListener()
        })
    }
    
    
    @ViewBuilder
    func chatBar() -> some View {
        HStack {
            TextField("Text message", text: $vm.message)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.black.opacity(0.8))
                .clipShape(Capsule())
                .alert(isPresented: $vm.showAlert, content: {
                    return Alert(title: Text(vm.errorMessage))
                })
            
            Spacer()
            
            Button {
                Task {
                    await vm.sendMessage(uid: message.fromId)
                }
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
                
                ForEach(vm.messages.sorted(by: {$0.date.dateValue() < $1.date.dateValue()})) {
                    ChatBubble(message: $0)
                }
                
                HStack{Spacer()}
                    .id(Keys.proxy)
                    .onReceive(vm.$count, perform: { _ in
                        withAnimation {
                            proxy.scrollTo(Keys.proxy)
                        }
                    })
                    
            }
        }
        .background(.black)
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 2) {
            Spacer()
            UserDot(size: 35, url: message.imageUrl)
            
            Text(message.username)
                .foregroundStyle(.white)
                .fontWeight(.thin)
            Spacer()
        }
    }
}

#Preview {
    Chatroom(message: Message.demo, vm: ChatViewModel())
    
}
