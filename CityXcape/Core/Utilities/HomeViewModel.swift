//
//  HomeViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/10/25.
//

import Foundation
import SwiftUI


@Observable
final class HomeViewModel {
    
    
    var messages: [Message] = []
    var requests: [Request] = []
    var count: Int = 0
    var reqCount: Int = 0
    var errorMessage: String = ""
    var showError: Bool = false
    
    init() {
        startListeningForRequest()
        fetchRecentMessages()
    }
    
    
    func startListeningForRequest() {
        DataService.shared.startListeningtoRequest { result in
            switch result {
            case .success(let newRequest):
                self.requests = newRequest
                self.reqCount = self.requests.count
            case .failure(let error):
                print("Error listening for request", error.localizedDescription)
            }
        }
    }
    
    func fetchRecentMessages() {
        DataService.shared.fetchRecentMessages { result in
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.messages = messages
                    self.count = messages.filter({$0.read == false}).count
                }
            case .failure(let error):
                print("Error fetching recent messages", error.localizedDescription)
            }
        }
    }
    
    func removeRequestListener() {
            DataService.shared.removeRequestListener()
        }
}
