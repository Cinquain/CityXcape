//
//  RequestViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/4/24.
//

import Foundation
import SwiftUI


class RequestViewModel: ObservableObject {
    
    @Published var requests: [Request] = [Request.demo, Request.demo2, Request.demo3, Request.demo4, Request.demo5, Request.demo6]
    @Published var showMatch: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var showPage: Bool = false 
    @Published var showTextField: Bool = false 
    @Published var message: String = ""
    
    init() {
//        fetchPendingRequest()
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
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }

    
}
