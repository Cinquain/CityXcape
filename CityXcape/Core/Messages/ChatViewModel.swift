//
//  ChatViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/18/24.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = [Message.demo]
    @Published var chatroom: [Message] = []
    
    
    @Published var count: Int = 0
    @Published var message: String = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    init() {

    }
    
    
    func fetchAllMessages() {
        DataService.shared.fetchRecentMessages { result in
            switch result {
            case .success(let messages):
                self.messages = messages
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }
    }
    
    func fetchMessageFor(uid: String) {
        DataService.shared.getMessagesFor(userId: uid) { result in
            switch result {
            case .success(let messages):
                self.chatroom = messages
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showAlert.toggle()
            }
        }
    }
    
    func sendMessage(uid: String) async {
        do {
            try await DataService.shared.sendMessage(userId: uid, content: message)
            self.message = ""
        } catch {
            self.errorMessage = error.localizedDescription
            self.showAlert.toggle()
        }
    }
    
    func removeChatListener() {
        DataService.shared.removeChatListener()
    }
    
    func removeMessageListener() {
        DataService.shared.removeRecentListener()
    }
    
    func deleteRecentMessage(uid: String)  {
        messages.removeAll(where: {$0.fromId == uid})
        DataService.shared.deleteRecentMessage(userId: uid)
    }
    
}
