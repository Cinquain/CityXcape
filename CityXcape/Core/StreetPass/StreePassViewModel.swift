//
//  StreePassViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/6/24.
//

import Foundation
import SwiftUI
import PhotosUI


class StreetPassViewModel: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadProfileImage(from: selectedImage)
            }
        }
    }
    
    @Published var user: User?
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    @Published var showPassport: Bool = false
    @Published var showPage: Bool = false
    @Published var showAuth: Bool = false
    
    @Published var buySTC: Bool = false
    @Published var showPicker: Bool = false 
    
    @Published var worlds: [World] = []
    @Published var stamps: [Stamp] = []
    
    init() {
        self.getUser()
    }
    
    
    func getUser() {
        Task {
            do {
                let credentials = try await DataService.shared.getUserCredentials()
                DispatchQueue.main.async {
                    self.user = credentials
                }
            } catch {
                print("Error finding user", error.localizedDescription)
                errorMessage = "No User Account Found"
                showError.toggle()
            }
        }
    }
    
    func getStamps() {
        Task {
            do {
                let stamps = try await DataService.shared.fetchAllStamps()
                DispatchQueue.main.async {
                    self.stamps = stamps
                }
                AnalyticService.shared.viewedPassport()
                showPassport.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    

    
    
    func loadProfileImage(from item: PhotosPickerItem?) async {
        guard let uid = AuthService.shared.uid else {return}
        guard let item = item else {return}
        guard let data = try? await item.loadTransferable(type: Data.self) else {return}
        guard let uiImage = UIImage(data: data) else {return}
        
        Task {
            do {
                let url = try await ImageManager.shared.uploadProfileImage(uid: uid, image: uiImage)
                getUser()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    

    
    //MARK: USER FUNCTIONS
    
    func signout() {
        do {
            try AuthService.shared.signOut()
        } catch {
            errorMessage = error.localizedDescription
            showError.toggle()
        }
    }
    
    func deleteAccount() {
        Task {
            do {
                try await DataService.shared.deleteUser()
                try await AuthService.shared.deleteUser()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func openCustomUrl(link: String) {
        guard let url = URL(string: link) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
}
