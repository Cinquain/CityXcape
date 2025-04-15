//
//  RequestViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/10/25.
//

import Foundation
import SwiftUI


@Observable
final class ConnectionsVM: Sendable {
    
    var requests: [Request] = [Request.demo, Request.demo2]
    var requestImage: String = ""
    var currentRequest: Request?
    
    
    var message: String = ""
    var showMatch: Bool = false
    var isSent: Bool = false
    var showDrodown: Bool = false
    
    var showError: Bool = false
    var errorMessage: String = ""
    var offset: CGFloat = -900
    var showMessage: Bool = false

    
    func startListeningForRequest() {
        DataService.shared.startListeningtoRequest { result in
            switch result {
            case .success(let newRequest):
                self.requests = newRequest
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
    
    func loadUserStreetPass(request: Request) async throws -> User {
        let user = try await DataService.shared.getUserFrom(uid: request.id)
        return user
    }
}
