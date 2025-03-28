//
//  StreePassViewModel.swift
//  CityXcape
//
//  Created by James Allan on 11/6/24.
//

import Foundation
import SwiftUI
import PhotosUI

@MainActor
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
    @Published var showStats: Bool = false 
    @Published var showRanks: Bool = false
    
    @Published var showPage: Bool = false
    @Published var showAuth: Bool = false
    @Published var showOnboarding: Bool = false
    @Published var spotMetric: LocationMetrics = .Checkins
    

    @Published var buySTC: Bool = false
    @Published var showPicker: Bool = false 
    
    @Published var worlds: [World] = []
    @Published var stamps: [Stamp] = []
    @Published var ranks: [UserRank] = []
    @Published var uploads: [Location] = []
    
    
    func getUser() {
        Task {
            do {
                let credentials = try await DataService.shared.getUserCredentials()
                DispatchQueue.main.async {
                    self.user = credentials
                }
            } catch {
                print("Error finding user", error.localizedDescription)
            }
        }
    }
    
    func getStamps() {
        Task {
            do {
                let stamps = try await DataService.shared.fetchAllStamps()
                self.stamps = stamps
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
                _ = try await ImageManager.shared.uploadProfileImage(uid: uid, image: uiImage)
                getUser()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    
    //MARK: ANALYTICS FUNCTIONS
    
    func getLeaderBoard() {
        Task {
            do {
                self.ranks = try await DataService.shared.fetchLeaderBoard().sorted(by: {$0.totalSales > $1.totalSales})
                self.showRanks.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func fetchAnalytics() {
        Task {
            do {
                self.uploads = try await DataService.shared.fetchScoutAnalytics()
                showStats.toggle()
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
                showError.toggle()
            }
        }
    }
    

    
    
}


extension StreetPassViewModel {
    
    //MARK: SETTING FUNCTIONS
    
    func signout() {
        do {
            try AuthService.shared.signOut()
            user = nil
            errorMessage = "Successfully Signed Out"
            showError.toggle()
        } catch {
            errorMessage = error.localizedDescription
            showError.toggle()
        }
    }
    
    
    func deleteAccount() {
        Task {
            do {
                try await DataService.shared.deleteUser()
                user = nil
                errorMessage = "Successfully Deleted Account"
                showError.toggle()
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
