//
//  PublicSPViewModel.swift
//  CityXcape
//
//  Created by James Allan on 4/10/25.
//

import Foundation
import SwiftUI


@Observable
final class PublicSPViewModel: Sendable {

    
    var user: User?
    var showRapSheet: Bool = false
    var isSent: Bool = false
    
    var message: String = ""
    var showTextField: Bool = false
    
    var showError: Bool = false
    var errorMessage: String = ""
    
    var walletValue: Int = 0
    var buySTC: Bool = false
    
    init() {
        getUser()
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
            }
        }
    }
    
    func compare(user: User) -> (String, String, Double) {
        var result: String = "View \(user.username)'s Rap Sheet"
        var percentage: String = "0% Match"
        let total: Double = 3
        guard let selfUser = self.user else {return (result, percentage, 0) }
        var count: Double = 0
        for world in user.worlds {
            if selfUser.worlds.contains(world) {
                count += 1
            }
        }
        if count == 0 {return (result, percentage, 0)}
        
        result = count > 1 ? "You and \(user.username) have \n \(count.clean) Worlds in Common"
                         : "You and \(user.username) have \n \(count.clean) World in Common"
        
        let percent: Double = (count / total) * 100
        if percent == 100 {
            result = "You and \(user.username) \n should connect "
        }
        percentage = "\(percent.clean)% Match"
        return (result, percentage, percent)
    }
    
    
    func sendRequest(_ uid: String) {
        if message.isEmpty {
            errorMessage = "Please enter a message"
            showError.toggle()
            return
        }
        
        guard let user = user else {return}
        
        let request = Request(id: user.id, username: user.username, imageUrl: user.imageUrl, content: message, spotId: "", worlds: user.worlds)
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
                    self.walletValue -= 1
                })
               
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
    func checkStreetCredforRequest(user: User) {
        if showTextField {
            sendRequest(user.id)
            return
        }
        Task {
            do {
                walletValue = try await DataService.shared.getStreetCred()
                if walletValue > 0 {
                    showTextField = true
                } else {
                    buySTC.toggle()
                    return
                }
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    func checkForStreetCred(uid: String) {
        if showTextField {
            sendRequest(uid)
            return
        }
        
        Task {
            do {
                walletValue = try await DataService.shared.getStreetCred()
                if walletValue > 0 {
                    showTextField = true
                } else {
                    buySTC.toggle()
                    return
                }
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
}
