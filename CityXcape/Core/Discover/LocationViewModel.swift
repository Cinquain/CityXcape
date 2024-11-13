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
    
    @Published var spotId: String = ""
    @Published var errorMessage: String = ""
    @Published var showPicker: Bool = false 
    
    @Published var showError: Bool = false
    @Published var stampImageUrl: String = ""
    @Published var users: [User] = [User.demo, User.demo2, User.demo3]
    @Published var meUser: User?
    
    
    func fetchCheckedInUsers(spotId: String) {
        checkin(spotId: spotId)
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
    
    func checkin(spotId: String) {
        Task {
            do {
                let user = try await DataService.shared.getUserCredentials()
                self.meUser = user
                try await DataService.shared.checkin(spotId: spotId, user: user)
                UserDefaults.standard.set(spotId, forKey: CXUserDefaults.lastSpotId)

            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    fileprivate func uploadStampImage(item: PhotosPickerItem?) async {
        guard let item = item else {return}
        guard let data = try? await item.loadTransferable(type: Data.self) else {return}
        guard let uiImage = UIImage(data: data) else {return}
        guard let uid = AuthService.shared.uid else {return}
        
        Task {
            do {
                let imageUrl = try await ImageManager.shared.uploadStampImage(uid: uid, spotId: spotId, image: uiImage)
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

