//
//  RequestViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/4/24.
//

import Foundation
import SwiftUI


class RequestViewModel: ObservableObject {
    
    @Published var requests: [Request] = []
    @Published var showMatch: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showPage: Bool = false 
    @Published var showTextField: Bool = false 
    @Published var message: String = ""
    
    init() {
        startListeningForRequest()
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
    
    func removeRequest(request: Request) {
        if let index = requests.firstIndex(of: request) {
            requests.remove(at: index)
            showPage.toggle()
        }
        Task {
            do {
                try await DataService.shared.removeRequest(request: request)
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
    func acceptRequest(request: Request) {
        if !showTextField {
            showTextField = true
            return
        }
        if message.isEmpty {
            errorMessage = "Please include a message"
            showError.toggle()
            return
        }
        
        Task {
            do {
                try await DataService.shared.acceptRequest(content: message, request: request)
                showMatch.toggle()
                if let index = requests.firstIndex(of: request) {
                    requests.remove(at: index)
                }
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }

    
}
