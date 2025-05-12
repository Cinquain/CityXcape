//
//  SessionManager.swift
//  CityXcape
//
//  Created by James Allan on 5/12/25.
//

import Foundation
import FirebaseFirestore
import Combine


@MainActor
final class SessionManager: ObservableObject {
    
    static let shared = SessionManager()
    
    @Published var isCheckedIn: Bool {
        didSet {
            UserDefaults.standard.set(isCheckedIn, forKey: CXUserDefaults.isCheckedIn)
        }
    }
    
    @Published var lastSpotId: String {
        didSet {
            UserDefaults.standard.set(lastSpotId, forKey: CXUserDefaults.lastSpotId)
        }
    }
    
    
    
    private init() {
        self.isCheckedIn = UserDefaults.standard.bool(forKey: CXUserDefaults.isCheckedIn)
        self.lastSpotId = UserDefaults.standard.string(forKey: CXUserDefaults.lastSpotId) ?? ""
        
        if isCheckedIn && !lastSpotId.isEmpty {
            
        }
    }
    
    func startSession(spotId: String) {
        self.lastSpotId = spotId
        self.isCheckedIn = true
    }
    
    func clearSession() {
        self.isCheckedIn = false
        self.lastSpotId = ""
    }
    
    
    private func getCurrentUserId() -> String {
        return AuthService.shared.uid ?? ""
    }
    
    
   
    
}
