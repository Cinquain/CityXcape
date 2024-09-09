//
//  DataService.swift
//  CityXcape
//
//  Created by James Allan on 8/26/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

let DB = Firestore.firestore()

final class DataService {
    
    static let shared = DataService()
    private init() {}
    var userRef = DB.collection(Server.users)
    var spotRef = DB.collection(Server.locations)
    
    //MARK: CREATE FUNCTIONS
    func createUser(auth: AuthDataResult) {
        let uid = auth.user.uid
        let email = auth.user.email
        
        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            User.CodingKeys.email.rawValue: email ?? "",
            User.CodingKeys.timestamp.rawValue: Timestamp(),
            User.CodingKeys.streetcred.rawValue: 3
        ]

        userRef.document(uid).setData(data)
        UserDefaults.standard.setValue(uid, forKey: CXUserDefaults.uid)
    }
    
    func createStreetPass(username: String, imageUrl: String, gender: Bool) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let data: [String: Any] = [
            User.CodingKeys.username.rawValue: username,
            User.CodingKeys.imageUrl.rawValue: imageUrl,
            User.CodingKeys.gender.rawValue: gender
        ]
        let ref = userRef.document(uid)
        try await ref.updateData(data)
        UserDefaults.standard.setValue(username, forKey: CXUserDefaults.username)
    }
    
    
    //MARK: USER FUNCTIONS
    func checkIfUserExist(uid: String) async throws -> Bool {
        if try await userRef.document(uid).getDocument().exists {
            try await loginUser(uid: uid)
            return true
        } else {
            return false
        }
    }
    
    func loginUser(uid: String) async throws {
        let user = try await getUserFrom(uid: uid)
        UserDefaults.standard.set(user.id, forKey: CXUserDefaults.uid)
    }
    
    
    //MARK: GET FUNCTIONS
    func getUserFrom(uid: String) async throws -> User {
        let snapshot = try await userRef.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        return user
    }
    
    func getSpotFrom(id: String) async throws -> Location {
        let snapshot = try await spotRef.document(id).getDocument()
        let location = try snapshot.data(as: Location.self)
        return location
    }
    
    //MARK: PUT FUNCTIONS
    func uploadImageUrl(uid: String, url: String) async throws {
        let data: [String: Any] = [
            User.CodingKeys.imageUrl.rawValue: url
        ]
        let ref = userRef.document(uid)
        try await ref.updateData(data)
    }
    
    
    //MARK: DELETE FUNCTIONS
    func deleteUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        try await ImageManager.shared.deleteUserProfile(uid: uid)
        try await userRef.document(uid).delete()
        try await Auth.auth().currentUser?.delete()
        
        //Removing user defaults
        UserDefaults.standard.removeObject(forKey: CXUserDefaults.uid)
        UserDefaults.standard.removeObject(forKey: CXUserDefaults.profileUrl)
        UserDefaults.standard.removeObject(forKey: CXUserDefaults.createdSP)
        UserDefaults.standard.removeObject(forKey: CXUserDefaults.firstOpen)
        
        //Sign out
        try AuthService.shared.signOut()
    }
    
}
