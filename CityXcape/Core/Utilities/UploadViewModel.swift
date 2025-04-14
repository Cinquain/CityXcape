//
//  UploadViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/4/24.
//

import Foundation
import PhotosUI
import SwiftUI



@MainActor
class UploadViewModel: ObservableObject {
        @Published var selectedImage: PhotosPickerItem? {
        didSet {
            switch imageCase {
            case .profile:
                Task { await loadProfileImage(from: selectedImage) }
            case .location:
                break
            case .stamp:
                break
            }
        }
    }
    
    @Published var postImage: UIImage?
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var imageUrl: String = ""
    @Published var imageCase: ImageCase = .profile
    
    
    @Published var username: String = ""
    @Published var gender: Bool = true
    @Published var city: String = ""
    @Published var worlds: [World] = []
    @Published var selectedWorlds: [World] = []
    
    
    func loadProfileImage(from item: PhotosPickerItem?) async {
        guard let uid = AuthService.shared.uid else {
            print("No user auth found")
            return}
        guard let item = item else {return}
        guard let data = try? await item.loadTransferable(type: Data.self) else {return}
        guard let uiImage = UIImage(data: data) else {return}
        
        Task {
            do {
                let url = try await ImageManager.shared.uploadProfileImage(uid: uid, image: uiImage)
                self.imageUrl = url
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
                print(error.localizedDescription)
            }
        }
    }
    
    func submitStreetPass() async throws {
        guard let uid = AuthService.shared.uid else {return}
        
        let user = User(id: uid, username: username, imageUrl: imageUrl, gender: gender, city: city, streetcred: 10, worlds: selectedWorlds, timestamp: Date(), fcmToken: "")
        try await DataService.shared.createStreetPass(user: user)
    }
    
    
    func addOrRemove(world: World) {
       if let index = selectedWorlds.firstIndex(of: world) {
           selectedWorlds.remove(at: index)
           errorMessage = "Removed \(world.name)"
           showError.toggle()
           return
       }
       if selectedWorlds.count < 3 {
           selectedWorlds.append(world)
           print(selectedWorlds)
           errorMessage = "Added \(world.name)"
           showError.toggle()
       }  else {
           errorMessage = "You've reached the max of 3 worlds"
           showError.toggle()
       }
   }
    
    func getWorlds()  {
        Task {
            do {
                let data = try await DataService.shared.fetchAllWorlds()
                worlds = data
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
                showError.toggle()
            }
        }
    }
    
    
   
    
}
