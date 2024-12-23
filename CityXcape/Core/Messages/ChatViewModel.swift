//
//  ChatViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/18/24.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    
    @Published var recents: [Message] = []
    @Published var messages: [Message] = []
    @Published var unviewed: [Message] = []
    
    
    @Published var count: Int = 0
    @Published var message: String = ""
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false
    
    init() {
        fetchRecentMessages()
    }
    
    
    func fetchRecentMessages() {
        DataService.shared.fetchRecentMessages { result in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.recents = messages
                    self.count = messages.filter({$0.read == false}).count
                }
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
                DispatchQueue.main.async {
                    self.messages = messages
                    self.count = 0
                    AnalyticService.shared.loadedChatroom()
                }
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
