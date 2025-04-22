//
//  LocationViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/12/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
final class LocationViewModel: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task  {await uploadStampImage(item: selectedImage) }
        }
    }
    
    @Published var showPicker: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    @Published var showTextField: Bool = false

    @Published var stampImageUrl: String = ""
    @Published var showOnboarding: Bool = false
  
    
    @Published var showLounge: Bool = false
    @Published var huntSpot: Location?
    @Published var socialHubSpot: Location?
    
    @Published var users: [User] = [User.demo, User.demo2, User.demo3]
    @Published var currentUser: User?
    @Published var user: User?
    @Published var spot: Location?
    @Published var worlds: [World] = []
    
    
    @Published var recents: [Message] = []
 
    @Published var count: Int = 0
    @Published var walletValue: Int = 0
    @Published var buySTC: Bool = false
    
    
    
    
    
    func fetchCheckedInUsers(spotId: String) {
        DataService.shared.fetchUsersCheckedIn(spotId: spotId) { result in
            switch result {
            case .success(let checkedInUsers):
                self.users = checkedInUsers
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showError.toggle()
            }
        }
    }
    
    func checkin(spotId: String) async throws -> Location {
        let currentspot = try await DataService.shared.getSpotFrom(id: spotId)
        UserDefaults.standard.setValue(currentspot.id, forKey: CXUserDefaults.lastSpotId)
        fetchCheckedInUsers(spotId: spotId)
        let user = try await DataService.shared.getUserCredentials()
        self.user = User(id: user.id, username: user.username, imageUrl: user.imageUrl, gender: user.gender, city: user.city, streetcred: user.streetcred, worlds: user.worlds, fcmToken: user.fcmToken)
        self.spot = currentspot
        try await DataService.shared.checkin(spotId: spotId, user: self.user!)
        AnalyticService.shared.checkedIn()
        return currentspot
    }
    
    func checkDistance() {
        guard let spot = spot else {return}
        if spot.distanceFromUser > 150 {
            Task {
                try await DataService.shared.checkout(spotId: spot.id)
            }
        }
    }
    
    func checkout(_ spotId: String) async throws {
        try await DataService.shared.checkout(spotId: spotId)
        NotificationManager.shared.cancelNotification()
        UserDefaults.standard.removeObject(forKey: CXUserDefaults.lastSpotId)
    }
    
    
    
    
    
    
    
   
 
    
}



//MARK: SCAVENGER HUNT FUNCTIONALITIES
extension LocationViewModel {
    
    fileprivate func uploadStampImage(item: PhotosPickerItem?) async {
        guard let item = item else {return}
        guard let data = try? await item.loadTransferable(type: Data.self) else {return}
        guard let uiImage = UIImage(data: data) else {return}
        guard let spot = spot else {return}
        guard let user = user else {return}
        
        Task {
            do {
                let imageUrl = try await ImageManager.shared.uploadStampImage(uid: user.id, spotId: spot.id, image: uiImage)
                DispatchQueue.main.async {
                    self.stampImageUrl = imageUrl
                }
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func createStamp(spot: Location) {
        Task {
            do {
                let user = try await DataService.shared.getUserCredentials()
                try await DataService.shared.createStamp(spot: spot, username: user.username)
            } catch {
                errorMessage = error.localizedDescription
                print(errorMessage)
            }
        }
    }
    
    func checkStreetCredforStamp() {
        Task {
            do {
                walletValue = try await DataService.shared.getStreetCred()
                if walletValue > 0 {
                    DataService.shared.updateStreetCred(count: -1)
                    showPicker.toggle()
                } else {
                    buySTC.toggle()
                    return
                }
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
}



