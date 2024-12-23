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

    @Published var message: String = ""
    @Published var showTextField: Bool = false

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
    
    
    @Published var requests: [Request] = []
    @Published var showPage: Bool = false
    @Published var stcValue: Int = 0
    
    
    
    init() {
        startListeningForRequest()
    }
    
    
    
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
        self.user = User(id: user.id, username: user.username, imageUrl: user.imageUrl, gender: user.gender, city: currentspot.name, streetcred: user.streetcred, worlds: user.worlds, fcmToken: user.fcmToken)
        self.spot = currentspot
        try await DataService.shared.checkin(spotId: spotId, user: self.user!)
        NotificationManager.shared.scheduleGeoNotification(spot: currentspot)
        NotificationManager.shared.scheduleTimeNotification(spot: currentspot)
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
    
    func checkout(spotId: String) async throws {
        try await DataService.shared.checkout(spotId: spotId)
        NotificationManager.shared.cancelNotification()
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
                let user = try await DataService.shared.getUserCredentials()
                try await DataService.shared.createStamp(spot: spot, username: user.username)
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
        
        result = count > 1 ? "\(count.clean) Worlds in Common" : "\(count.clean) World in Common"
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
                AnalyticService.shared.sentRequest()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    self.isSent = false
                    self.stcValue -= 1
                })
               
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
    
    //MARK: REQUEST FUNCTIONALITIES
        
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
    
    func startListeningForRequest() {
        DataService.shared.startListeningtoRequest { result in
            switch result {
            case .success(let newRequest):
                self.requests = newRequest
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.showError.toggle()
            }
        }
    }
    
    func removeRequest(request: Request) {
   
        Task {
            do {
                try await DataService.shared.removeRequest(request: request)
                if let index = requests.firstIndex(of: request) {
                    requests.remove(at: index)
                    
                }
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func acceptRequest(request: Request) {
        Task {
            do {
                try await DataService.shared.acceptRequest(content: message, request: request)
                if let index = requests.firstIndex(of: request) {
                    requests.remove(at: index)
                }
                errorMessage = "You and \(request.username) are now connected and can chat"
                showError.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
    func loadUserStreetPass(request: Request) async throws -> User {
        if let user = users.first(where: {$0.id == request.id}) {
            print("Found user from checkins")
            return user
        } else {
            let user = try await DataService.shared.getUserFrom(uid: request.id)
            return user
        }
    }
 
    
}

