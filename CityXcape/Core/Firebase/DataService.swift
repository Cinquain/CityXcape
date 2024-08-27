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
    
    //MARK: USER FUNCTIONS
    func createUser(result: AuthDataResult) {
        let uid = result.user.uid
        let email = result.user.email
        
        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            User.CodingKeys.email.rawValue: email,
            User.CodingKeys.timestamp.rawValue: Timestamp(),
            User.CodingKeys.streetcred.rawValue: 3
        ]

        userRef.document(uid).setData(data)
        UserDefaults.standard.setValue(uid, forKey: CXUserDefaults.uid)
    }
    
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
    
    func getUserFrom(uid: String) async throws -> User {
        let snapshot = try await userRef.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        return user
    }
}
