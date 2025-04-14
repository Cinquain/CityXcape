//
//  RequestViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/10/25.
//

import Foundation
import SwiftUI


@Observable
final class RequestViewModel: Sendable {
    
    var requests: [Request] = [Request.demo, Request.demo2]
    var requestImage: String = ""
    
    var message: String = ""
    var showMatch: Bool = false
    
    var showError: Bool = false
    var errorMessage: String = ""
    
    var showMessage: Bool = false

    
    func startListeningForRequest() {
        DataService.shared.startListeningtoRequest { result in
            switch result {
            case .success(let newRequest):
                self.requests = newRequest
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showError.toggle()
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
    
    func acceptRequest(request: Request) {
        requestImage = request.imageUrl
        Task {
            do {
                try await DataService.shared.acceptRequest(content: message, request: request)
                showMatch = true
                if let index = requests.firstIndex(of: request) {
                    requests.remove(at: index)
                }
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
