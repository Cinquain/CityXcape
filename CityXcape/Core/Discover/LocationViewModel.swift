//
//  LocationViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/12/24.
//

import Foundation
import SwiftUI
import PhotosUI


class LocationViewModel: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task  {await uploadStampImage(item: selectedImage) }
        }
    }
    
    @Published var showPicker: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""

    @Published var message: String = ""
    @Published var  showTextField: Bool = false

    @Published var stampImageUrl: String = ""
    @Published var showOnboarding: Bool = false
    @Published var isSent: Bool = false
    
    @Published var showLounge: Bool = false 
    @Published var huntSpot: Location?
    

    
    @Published var users: [User] = []
    @Published var currentUser: User?
    @Published var user: User?
    @Published var spot: Location?
    @Published var worlds: [World] = []
    
    
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
        self.user = user
        self.spot = currentspot
        try await DataService.shared.checkin(spotId: spotId, user: user)
        return currentspot
    }
    
    func checkout(spotId: String) async throws {
        try await DataService.shared.checkout(spotId: spotId)
        UserDefaults.standard.removeObject(forKey: CXUserDefaults.lastSpotId)
    }
    
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
                try await DataService.shared.createStamp(spot: spot)
            } catch {
                errorMessage = error.localizedDescription
                print(errorMessage)
            }
        }
    }
    
    func compare(worlds: [World]) -> (String, String) {
        var result: String = "No World in Common"
        var percentage: String = "0% Match"
        let total: Double = 3
        guard let user = user else {return (result, percentage) }
        var count: Double = 0
        for world in worlds {
            if user.worlds.contains(world) {
                count += 1
            }
        }
        if count == 0 {return (result, percentage)}
        
        result = count > 1 ? "\(count) Worlds in Common" : "\(count) World in Common"
        let percent: Double = (count / total) * 100
        percentage = "\(percent.clean)% Match"
        return (result, percentage)
    }
    
    func sendRequest(uid: String) {
        if message.isEmpty {
            errorMessage = "Please enter a message"
            showError.toggle()
            return
        }
        
        guard let user = user else {return}
        guard let spot = spot else {return}
        
        let request = Request(id: user.id, username: user.username, imageUrl: user.imageUrl, content: message, spotId: spot.id, spotName: spot.name, worlds: user.worlds)
        Task {
            do {
                try await DataService.shared.sendRequest(userId: uid, request: request)
                message = ""
                showTextField = false
                isSent = true
                SoundManager.shared.playBeep()
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.isSent = false
                })
               
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
 
    
}

