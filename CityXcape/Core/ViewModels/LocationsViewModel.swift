//
//  LocationsViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/21/23.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class LocationsViewModel: ObservableObject {
    @AppStorage(AppUserDefaults.streetcred) var streetcred: Int?
    @AppStorage(AppUserDefaults.uid) var uid: String?

    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var normalAlert: Bool = false
    @Published var currentIndex: Int = 0
    @Published var showExtraImage: Bool =  false
    
    @Published var offset: CGFloat = 550
    @Published var showSignUp: Bool = false
    @Published var extraImages: [String] = []
    
    @Published var showDetails: Bool = false
    @Published var showGallery: Bool = false 
    @Published var showCheckinList: Bool = false
    
    @Published var showBucketList: Bool = false 
    @Published var showStamp: Bool = false
    @Published var isCheckedIn: Bool = false 
    
    @Published var opacity: Double = 0
    @Published var basicAlert: Bool = false
    
    @Published private(set) var locations: [Location] = []
    @Published var worlds: [World] = []
    @Published var saves: [Location] = []
    @Published var user: User?
    
    @Published var option: SpotOptions = .none
    @Published var showWorldMenu: Bool = false
    @Published var askPasscode: Bool = false 
    
    
    

 
    //MARK: TOP 3 BUTTONS
    func seeMoreInfo() {
        if option == .showInfo {option = .none}
        else { option = .showInfo }
        self.opacity = option == .showInfo ? 1 : 0
        Analytic.shared.viewedSpotInfo()
    }
    
    func likeLocation(spot: Location) {
        if checkAuth(message: "like") == false {return}
        if option ==  .like {option = .none}
        else {option = .like}
     
        Task {
            do {
                try await DataService.shared.likeOrUnlike(spot: spot)
                if option == .like {alertMessage = "Liked \(spot.name)"; normalAlert.toggle(); showAlert.toggle();}
            } catch {
                normalAlert.toggle()
                alertMessage = error.localizedDescription
                showAlert.toggle()
                normalAlert = false
            }
        }
    }
    
    func saveToBookmark(spot: Location) {
        if checkAuth(message: "bookmark") == false {return}
        if option == .bookmark {option = .none}
        else {option = .bookmark}
        
        Task {
            do {
                try await  DataService.shared.saveOrUnsaveLocation(spot: spot)
                if option == .bookmark {
                    let savesIds = try await DataService.shared.fetchBucketlist()
                    self.saves = try await DataService.shared.getSpotsFromIds(ids: savesIds)
                    self.showBucketList.toggle()
                    Analytic.shared.savedLocation()
                }
            } catch {
                normalAlert.toggle()
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    //MARK: BOTTOM 3 BUTTONS
    func showDirections(spot: Location) {
//        if checkAuth(message: "GPS") == false {return}
        if option == .showMap {option = .none; return}
        else {option = .showMap}
        
        if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                            UIApplication.shared.open(url, options: [:])
                        }
        } else {
            //Opens in browser
            if let url = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(spot.latitude),\(spot.longitude)&directionsmode=driving") {
                            UIApplication.shared.open(url)
                        }
        }
        
    }
    
    func showImages() {
        //        if checkAuth(message: "see images of") == false {return}
        if extraImages.isEmpty || extraImages.count == 1 {return}
        showExtraImage = true
        if currentIndex < extraImages.count - 1  {
            currentIndex += 1
            return
        } else {
            currentIndex = 0
            return
        }
    }
   
    
    //MARK: CHECK-IN LOCATION
    func checkinLocation(spot: Location) {
        if checkAuth(message: "checkin") == false {return}
        if checkDistance(spot: spot) == false {return}
        //Give User a Stamp
        //Increment Wave Count On User Object
        Task {
            do {
                try await DataService.shared.checkinLocation(spot: spot)
                DispatchQueue.main.async {
                    self.showStamp = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.normalAlert = true
                        self.alertMessage = "\(spot.name) has been added to your passport"
                        self.showAlert = true
                    })
                }
             
                
            } catch {
                normalAlert.toggle()
                alertMessage = error.localizedDescription
                self.showAlert = true
                normalAlert = false 
            }
        }
    }
    
  
    //MARK: DAEMON FUNCTIONS
    func updateViewCount(spot: Location) {
        Task {
            do {
                try await DataService.shared.updateViewCount(spotId: spot.id)
                getOwnerInfo(uid: spot.ownerId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getAllLocations() {
        Task {
            do {
                self.locations = try await DataService.shared.fetchAllLocations()
                self.locations.sort(by: {$0.distanceFromUserinMiles < $1.distanceFromUserinMiles})
            } catch {
                alertMessage = error.localizedDescription
                showAlert.toggle()
            }
        }
    }
    
    func getOwnerInfo(uid: String) {
        Task {
            do {
                let user = try await DataService.shared.getUserFrom(id: uid)
                self.user = user
            } catch {
                print("Error finding user who owns the spot", error.localizedDescription)
            }
        }
    }
    
    func checkAuth(message: String) -> Bool {
        if AuthService.shared.uid == nil {
            alertMessage = "You need an account to \(message) this location"
            showAlert.toggle()
            return false
        } else {
            return true
        }
    }
    
    func checkDistance(spot: Location) -> Bool {
        if spot.distanceFromUser < 200 {
            return true
        } else {
            normalAlert.toggle()
            alertMessage = "You have to be inside to checkin"
            print("Distance from user is: \(spot.distanceFromUser)")
            showAlert.toggle()
            return false
        }
    }
    
    
    
    
}
