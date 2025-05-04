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
class AuthViewModel: ObservableObject {
    
    @AppStorage(CXUserDefaults.fcmToken) var fcmToken: String?

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
    @Published var showPicker: Bool = false 
    @Published var imageCase: ImageCase = .profile
    
    @Published var showPassport: Bool = false 
    @Published var username: String = ""
    @Published var searchQuery: String = ""
    @Published var isChecked: Bool = false

    @Published var gender: Bool = true
    @Published var worlds: [World] = []
    @Published var selectedWorlds: [World] = []
    @Published var city: String = ""
    
    var manager = LocationService.shared

    
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
    
    func submitNameGender() {
        Task {
            do {
                try await DataService.shared.createUserName(name: username, gender: gender)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

    
    func getWorlds()  {
        Task {
            do {
                let data = try await DataService.shared.fetchAllWorlds()
                self.worlds = data
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
                showError.toggle()
            }
        }
    }
    
    func subbmitWorlds() {
        Task {
            do {
                try await DataService.shared.saveUserWorlds(worlds: selectedWorlds)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkAllFields() -> Bool {
        guard let uid = AuthService.shared.uid else {
            errorMessage = "Please sign up using Apple or Google"
            showError.toggle()
            return false
        }
        
        if isChecked == false {
            errorMessage = "Please agree to user terms and agreements"
            showError.toggle()
            return false
        }
        
        if username.isEmpty {
            errorMessage = "Please create a username and select your gender"
            showError.toggle()
            return false
        }
        if username.count < 3 {
            errorMessage = "Your username must be at least 3 characters long"
            showError.toggle()
            return false
        }
        
        if imageUrl.isEmpty {
            errorMessage = "Please upload a selfie"
            showError.toggle()
            return false
        }
        
        if selectedWorlds.isEmpty {
            errorMessage = "Please choose at least one world"
            showError.toggle()
            return false
        }
        return true
    }
    
    
   
    
}
