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
    @Published var offset: CGFloat = 0
    @Published var showMatch: Bool = false 
    @Published var cardViews: [Cardview] = []
    @Published var lastCardIndex: Int = 4
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init() {
        fetchPendingRequest()
    }
    var dragThreshold: CGFloat = 65.0
    
 
    func match(request: Request) {
        offset = 1000
        withAnimation {
            moveCards()
        }
        showMatch.toggle()
    }
    
    func unmatch(request: Request) {
        offset = -1000
        moveCards()
        withAnimation {
          moveCards()
        }
    }
    
    
    func isTopCard(cardView: Cardview) -> Bool {
        guard let index = cardViews.firstIndex(where: {$0.id == cardView.id}) else {return false}
        return index == 0
    }
    
    func moveCards() {
        cardViews.removeFirst()
        //Remove request from DB whether pass or rejected
        
    }
    
    func fetchPendingRequest() {
        Task {
            do {
                let loadedRequest = try await DataService.shared.fetchAllRequests()
                DispatchQueue.main.async {
                    self.requests = loadedRequest
                    self.generateCards()
                }
               
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func generateCards() {
        //Fetch the request from Database
        for request in requests {
            let cardView = Cardview(request: request)
            cardViews.append(cardView)
        }
    }
    
}
