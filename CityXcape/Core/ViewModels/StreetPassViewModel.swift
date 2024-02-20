//
//  StreetPassViewModel.swift
//  CityXcape
//
//  Created by James Allan on 9/4/23.
//

import SwiftUI
import MapKit
import PhotosUI
import FirebaseAuth

class StreetPassViewModel: NSObject, ObservableObject {
    
    @Published var selectedItem: UIImage? {
        didSet {
            setProfileImage(from: selectedItem)
        }
    }
    
    @Published var stampSelection: UIImage?
    @Published var showSignUp: Bool = false
    
    @Published var profileImage: UIImage?
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    @Published var isUploading: Bool = false
    @Published var editSP: Bool = false
    
    var username: String = ""
    @Published var profileUrl: String = ""
    @Published var bio: String = ""
    @Published var changedGender: Bool = false
    @Published var changedAge: Bool = false
    @Published var changedStatus: Bool = false
    @Published var success: Bool = false
    
    @Published var showBucketList: Bool = false
    @Published var bucketList: [Location] = []
    
    @Published var showPicker: Bool = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showActionSheet: Bool = false
    
    
    @Published var showDiary: Bool = false
    @Published var stamps: [Stamp] = []
    
    @Published var showStreetRep: Bool = false
    @Published var uploads: [Location] = []
    @Published var currentSpot: Location?
    @Published var data: [(name: String, count: Int)] = []
    
    @Published var metricsCategory: MetricCategory = .Views
    @Published var spotMetric: SpotMetric = .Metrics
    @Published var users: [User] = []
    
    @Published var spotId: String = ""
    @Published var editTitle: String = ""
    @Published var editDetails: String = ""
    @Published var longitude: String = ""
    @Published var latitude: String = ""
    @Published var isDeleted: Bool = false
    
    @Published var showImagePicker: Bool = false
    @Published var thumbcase: ImageCase = .one
    @Published var stampImageUrl = ""
    @Published var spotImageUrl = ""
    @Published var extraImage: UIImage? = nil
    @Published var extraImageII: UIImage? = nil
    @Published var imageSelection: UIImage?  = nil {
        didSet {
            setSpotImage(from: imageSelection)
        }
    }
    @Published var isMale: Bool = true {
        didSet {
            changedGender = true
        }
    }
    @Published var single: Bool = false {
        didSet {
            changedStatus = true
        }
    }
    
    @Published var age: String = "" {
        didSet {
            changedAge = true
        }
    }
    
    func fetchUploads() {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to view analytics"
            showAlert.toggle()
            return
        }
        
        Task {
            do {
                let uploadIds = try await DataService.shared.fetchUserUploads()
                self.uploads = try await DataService.shared.getSpotsFromIds(ids: uploadIds)
                self.calculateAnalytics()
                showStreetRep.toggle()
            } catch {
                alertMessage = error.localizedDescription
                
                showAlert.toggle()
            }
        }
    }
    
    func calculateAnalytics() {
        let totalLikes = uploads.reduce(0, {$0 + $1.likeCount})
        let totalSaves = uploads.reduce(0, {$0 + $1.saveCount})
        let totalCheckins = uploads.reduce(0, {$0 + $1.checkinCount})
        let totalViews = uploads.reduce(0, {0 + $1.viewCount})
        data.append((name: "Likes", count: totalLikes))
        data.append((name: "Saves", count: totalSaves))
        data.append((name: "Check-ins", count: totalCheckins))
        data.append((name: "Views", count: totalViews))
    }
    
    //MARK: PRIMARY ACTIONS
    func fetchBucketList() {
        
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to create a bucket list"
            showAlert.toggle()
            return
        }
        
        Task {
            do {
                let saveIds = try await DataService.shared.fetchBucketlist()
                self.bucketList = try await DataService.shared.getSpotsFromIds(ids: saveIds)
                DispatchQueue.main.async {
                    self.showBucketList.toggle()
                }
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func fetchStamps() {
        
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to get a passport"
            showAlert.toggle()
            return
        }
        
        Task {
            do {
                self.stamps = try await DataService.shared.fetchallstamps()
                DispatchQueue.main.async {
                    self.showDiary.toggle()
                }
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func editStreetPass() {
        editSP.toggle()
    }
    
    func showSignup() {
        showSignUp.toggle()
    }
    
    
    //MARK: LOCATION EDIT FUNCTIONS
    func setSpotImage(from selection: UIImage?) {
        guard let selection else {return}
        isUploading = true
        Task {
            do {
                spotImageUrl = try await ImageManager.shared.uploadLocationImage(id: spotId, image: selection)
                try await DataService.shared.updateSpotImageUrl(spotId: spotId, imageUrl: spotImageUrl)
                isUploading = false
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
                isUploading = false
                return
            }
        }
    }
    
    func setExtraImage(from selection: UIImage?) {
        guard let selection else {return}
        isUploading = true
        Task {
            do {
                let imageUrl = try await ImageManager.shared.uploadLocationExtraImage(id: spotId, image: selection)
                try await DataService.shared.updateSpotExtraImage(spotId: spotId, imageUrl: imageUrl)
                alertMessage = "Added Extra Images Successfully"
                isUploading = false
                showAlert.toggle()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
                isUploading = false
            }
        }
    }
    
    func submitLocationChanges(spotId: String) {
        if !editTitle.isEmpty {
            changeTitle(id: spotId)
        }
        if !editDetails.isEmpty {
            changeDetails(id: spotId)
        }
        if !longitude.isEmpty {
            changeLong(id: spotId)
        }
        if !latitude.isEmpty {
            changeLat(id: spotId)
        }
        
        if let extraI = extraImage {setExtraImage(from: extraI)}
        if let extraII = extraImageII {setExtraImage(from: extraII)}
        
    }
    
    func changeTitle(id: String) {
        Task {
            do {
                try await DataService.shared.updateTitle(spotId: id, title: editTitle)
                alertMessage = "Updated Successfully"
                editTitle = ""
                showAlert.toggle()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func changeDetails(id: String) {
        Task {
            do {
                try await DataService.shared.updateDetail(spotId: id, detail: editDetails)
                alertMessage = "Updated Successfully"
                editDetails = ""
                showAlert.toggle()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func changeLong(id: String) {
        Task {
            do {
                try await DataService.shared.updateLongitude(spotId: id, longitude: longitude)
                alertMessage = "Longitude Changed Successfully"
                longitude = ""
                showAlert.toggle()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
        
    }
    
    func changeLat(id: String) {
        Task {
            do {
                try await DataService.shared.updateLatitude(spotId: id, latitude: latitude)
                alertMessage = "Title Latitude Successfully"
                latitude = ""
                showAlert.toggle()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func changeSpotImageUrl(id: String, spoturl: String) {
        Task {
            do {
                try await DataService.shared.updateSpotImageUrl(spotId: id, imageUrl: spoturl)
                alertMessage = "Image Changed Successfully!"
                showAlert.toggle()
                isDeleted = true 
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    //MARK: DELETE FUNCTIONS
    func deleteLocation(spotId: String) {
        Task {
            do {
                try await DataService.shared.deleteLocation(spotId: spotId)
                alertMessage = "Spot Successfully Deleted"
                showAlert.toggle()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    
    
}

extension StreetPassViewModel {
    //MARK: USER MANAGEMENT

    private func setProfileImage(from selection: UIImage?) {
        guard let selection else {return}
        let uid = Auth.auth().currentUser?.uid ?? ""
        Task {
            do {
                profileImage = selection
                let imageUrl = try await ImageManager.shared.uploadProfileImage(uid: uid, image: selection)
                try await DataService.shared.updateImageUrl(url: imageUrl)
                await MainActor.run(body: {
                    self.profileUrl = imageUrl
                })
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
                return
            }
        }
    }
    
    func createStreetPass() async throws {
        isUploading = true
        if profileImage == nil {
            alertMessage = "Upload a photo for your Street ID Card"
            showAlert.toggle()
            isUploading = false
        }
        
        if username.isEmpty {
            alertMessage = "Please create a username 😤"
            showAlert.toggle()
            isUploading = false
        }
        
        Task {
            try await DataService.shared.uploadStreetPass(imageUrl: profileUrl, username: username)
            success = true
            isUploading = false
        }
        
    }
    
    func updateUsername() {
        if !username.isEmpty {
            let data: [String: Any] = [
                User.CodingKeys.username.rawValue: username
            ]
            updateSPData(data: data)
            UserDefaults.standard.set(username, forKey: AppUserDefaults.username)
            username = ""
        }
    }
        
        func signOut() {
            //Sign out & clear user defaults
            do {
                try AuthService.shared.signOut()
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
        
        func deleteAccount() {
            Task {
                do {
                    try await DataService.shared.deleteUser()
                } catch {
                    alertMessage = error.localizedDescription
                    showAlert.toggle()
                }
            }
        }
        
        
        func submitProfileChanges() {
            isUploading.toggle()
            if !username.isEmpty {
                UserDefaults.standard.set(username, forKey: AppUserDefaults.username)
                let data: [String: Any] = [
                    User.CodingKeys.username.rawValue: username
                ]
                updateSPData(data: data)
                username = ""
            }
            if !bio.isEmpty {
                UserDefaults.standard.set(bio, forKey: AppUserDefaults.bio)
                let data: [String: Any] = [
                    User.CodingKeys.bio.rawValue: bio
                ]
                updateSPData(data: data)
                bio = ""
            }
            
            if changedStatus {
                let data: [String: Any] = [
                    "single": single
                ]
                updateSPData(data: data)
                changedStatus = false
            }
            
            if changedGender {
                let data: [String: Any] = [
                    "isMale": isMale
                ]
                updateSPData(data: data)
                changedGender = false
            }
            
            if changedAge {
                UserDefaults.standard.set(age, forKey: AppUserDefaults.age)
                let data: [String: Any] = [
                    "age": Int(age) ?? 0
                ]
                updateSPData(data: data)
                age = "0"
                changedAge = false
            }
            isUploading = false
        }
        
        func updateSPData(data: [String: Any]) {
            Task {
                do {
                    try await DataService.shared.updateStreetPass(data: data)
                    alertMessage = "StreetPass Successfully Updated!"
                    Analytic.shared.editStreetPass()
                    showAlert.toggle()
                } catch {
                    alertMessage = error.localizedDescription
                    showAlert.toggle()
                }
            }
        }
        
        
        
    }
    
    

