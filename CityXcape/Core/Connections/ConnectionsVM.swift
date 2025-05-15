//
//  RequestViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/10/25.
//

import Foundation
import SwiftUI



final class ConnectionsVM: ObservableObject {
    
    @Published var requests: [Request] = []
    @Published var requestImage: String = ""
    @Published var currentRequest: Request?
    @Published var count: Int = 0
    
    @Published var message: String = ""
    @Published var showMatch: Bool = false
    @Published var isSent: Bool = false
    @Published var showDrodown: Bool = false
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var offset: CGFloat = -900
    @Published var showMessage: Bool = false
    
    init() {

    }

    
    func startListeningForRequest() {
        DataService.shared.startListeningtoRequest { result in
            switch result {
            case .success(let newRequest):
                self.requests = newRequest
                self.count = newRequest.count
            case .failure(let error):
                print("Error finding request", error.localizedDescription)
            }
        }
    }
    
    func fetchPendingRequest() {
           Task {
               do {
                   let loadedRequest = try await DataService.shared.fetchAllRequests()
                   DispatchQueue.main.async { 
                       self.requests = loadedRequest
                   }
                  
               } catch {
                   errorMessage = error.localizedDescription
                   showError.toggle()
               }
           }
       }
    
    func removeRequestListener() {
        DataService.shared.removeRequestListener()
    }
    
    func removeRequest(request: Request) {
   
        Task {
            do {
                try await DataService.shared.removeRequest(request: request)
                if let index = requests.firstIndex(of: request) {
                    requests.remove(at: index)
                    
                }
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func acceptRequest(request: Request?) {
        guard let request = request else {return}
        if message.isEmpty {
            errorMessage = "Please respond to \(request.username)"
            showError.toggle()
            return
        }
        Task {
            do {
                try await DataService.shared.acceptRequest(content: message, request: request)
                isSent = true
                message = ""
                SoundManager.shared.playBeep()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.offset = -900
                    self.showDrodown = false
                    if let index = self.requests.firstIndex(of: request) {
                        self.requests.remove(at: index)
                    }
                })
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func returnOverlay() {
        offset = -900
        showDrodown = false
        message = ""
    }
    
    func loadUserStreetPass(request: Request) async throws -> User {
        let user = try await DataService.shared.getUserFrom(uid: request.id)
        return user
    }
    
 
}
