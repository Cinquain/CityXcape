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

    
}
