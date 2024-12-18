//
//  Analytic.swift
//  CityXcape
//
//  Created by James Allan on 12/18/24.
//

import Foundation
import FirebaseAnalytics



final class Analytic {
    
    static let shared = Analytic()
    private init() {}
    
    func pressedCheckin() {
        Analytics.logEvent("pressed_checkin", parameters: nil)
    }
    
    func googleSignup() {
        Analytics.logEvent("chose_google_signup", parameters: nil)
    }
    
    func appleSignup() {
        Analytics.logEvent("chose_apple_signup", parameters: nil)
    }
    
    func loginUser() {
        Analytics.logEvent("user_login", parameters: nil)
    }
    
    func startedOnboarding() {
        Analytics.logEvent("started_onboarding", parameters: nil)
    }
    
    func newUser() {
        Analytics.logEvent("new_user", parameters: nil)
    }
    
    func checkedIn() {
        Analytics.logEvent("checkin", parameters: nil)
    }
    
    func checkout() {
        Analytics.logEvent("checkout", parameters: nil)
    }
    
    func viewStreetPass() {
        Analytics.logEvent("viewed_streetpass", parameters: nil)
    }
    
    func viewedWorld() {
        Analytics.logEvent("viewed_world", parameters: nil)
    }
    
    func sentRequest() {
        Analytics.logEvent("sent_request", parameters: nil)
    }
    
    func viewedRequest() {
        Analytics.logEvent("viewed_request", parameters: nil)
    }
    
    func deniedRequest() {
        Analytics.logEvent("denied_request", parameters: nil)
    }
    
    func newConnection() {
        Analytics.logEvent("new_connection", parameters: nil)
    }
    
    func viewOrderPage() {
        Analytics.logEvent("viewed_order_page", parameters: nil)
    }
    
    func purchasedSTC() {
        Analytics.logEvent("purchased_STC", parameters: nil)
    }
    
    func ordered3STC() {
        Analytics.logEvent("ordered_3STC", parameters: nil)
    }
    
    func ordered15STC() {
        Analytics.logEvent("ordered_15STC", parameters: nil)
    }
    
    func ordered50STC() {
        Analytics.logEvent("ordered_50STC", parameters: nil)
    }
    
    func viewedPassport() {
        Analytics.logEvent("viewed_passport", parameters: nil)
    }
    
    func newStamp() {
        Analytics.logEvent("new_stamp", parameters: nil)
    }
    
    func sentMessage() {
        Analytics.logEvent("sentMessage", parameters: nil)
    }
    
    func uploadedProfilePic() {
        Analytics.logEvent("uploaded_profile_pic", parameters: nil)
    }
    
    func loadedChatroom() {
        Analytics.logEvent("loaded_chatroom", parameters: nil)
    }
    
}
