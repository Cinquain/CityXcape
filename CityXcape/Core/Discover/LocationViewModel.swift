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
    
    @Published var errorMessage: String = ""
    @Published var showPicker: Bool = false 
    
    @Published var showError: Bool = false
    @Published var stampImageUrl: String = ""
    @Published var users: [User] = [User.demo]
    @Published var user: User?
    @Published var spot: Location?
    
    
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
        fetchCheckedInUsers(spotId: spotId)
        let user = try await DataService.shared.getUserCredentials()
        self.user = user
        self.spot = currentspot
        try await DataService.shared.checkin(spotId: spotId, user: user)
        return currentspot
    }
    
    func checkout(spotId: String) async throws {
        try await DataService.shared.checkout(spotId: spotId)
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
    
}

