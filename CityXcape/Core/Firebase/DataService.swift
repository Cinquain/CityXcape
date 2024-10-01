//
//  DataService.swift
//  CityXcape
//
//  Created by James Allan on 8/26/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

let DB = Firestore.firestore()

final class DataService {
    
    static let shared = DataService()
    private init() {}
    
    var userRef = DB.collection(Server.users)
    var spotRef = DB.collection(Server.locations)
    var chatRef = DB.collection(Server.messages)
    var connectRef = DB.collection(Server.connections)
    var recentRef = DB.collection(Server.recentMessage)
    var worldRef = DB.collection(Server.world)
    
    var chatListener: ListenerRegistration?
    var checkinListener: ListenerRegistration?
    var recentMessageListener: ListenerRegistration?
    
    @AppStorage(CXUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CXUserDefaults.username) var username: String?
    
    //MARK: AUTH FUNCTIONS
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
    
    func loginUser(uid: String) async throws {
        let user = try await getUserFrom(uid: uid)
        UserDefaults.standard.set(user.id, forKey: CXUserDefaults.uid)
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
    
    func updateStreetCred(count: Double) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = userRef.document(uid)
        let data: [String: Any] = [
            User.CodingKeys.streetcred.rawValue: FieldValue.increment(count)
        ]
        try await reference.updateData(data)
    }
    
    func getUserFrom(uid: String) async throws -> User {
        let snapshot = try await userRef.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        return user
    }
    
    func uploadImageUrl(uid: String, url: String) async throws {
        let data: [String: Any] = [
            User.CodingKeys.imageUrl.rawValue: url
        ]
        let ref = userRef.document(uid)
        try await ref.updateData(data)
    }
    
    
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
    
    //MARK: LOCATION FUNCTIONS
    func getSpotFrom(id: String) async throws -> Location {
        let snapshot = try await spotRef.document(id).getDocument()
        let location = try snapshot.data(as: Location.self)
        return location
    }
    
    //MARK: WORLD FUNCTIONS
    func fetchAllWorlds() async throws -> [World] {
        var worlds: [World] = []
        let snapshot = try await worldRef.getDocuments()
        try snapshot.documents.forEach { document in
            let world = try document.data(as: World.self)
            worlds.append(world)
        }
        return worlds
    }

    //MARK: CONNECTION FUNCTIONS
    func sendRequest(userId: String, location: String, message: String) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let imageUrl = profileUrl ?? ""
        let username = username ?? ""
        
        let reference = connectRef.document(userId)
                                  .collection(Server.request)
                                  .document(uid)
        
        let data: [String: Any] = [
            Message.CodingKeys.id.rawValue: reference.documentID,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.toId.rawValue: userId,
            Message.CodingKeys.content.rawValue: message,
            Message.CodingKeys.timestamp.rawValue: Timestamp(),
            Message.CodingKeys.ownerImageUrl.rawValue: imageUrl,
            Message.CodingKeys.displayName.rawValue: username,
            Message.CodingKeys.spotName.rawValue: location
        ]
        
        try await reference.setData(data)
    }
    
    func deleteUser(userId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let reference = connectRef.document(uid).collection(Server.connections).document(userId)
        let referenceII = connectRef.document(userId).collection(Server.connections).document(uid)
        try await reference.delete()
        try await referenceII.delete()
    }
    
    func acceptRequest(message: Message) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        //Create chat references
        let messageRef = chatRef.document(uid).collection(message.fromId).document()
        let messageRefII = chatRef.document(message.fromId).collection(uid).document()
        try messageRef.setData(from: message)
        try messageRefII.setData(from: message)
        
        //Create recent message references
        let recentRef = chatRef.document(Server.recentMessage).collection(uid).document(message.fromId)
        let recentRefII = chatRef.document(Server.recentMessage).collection(message.fromId).document(uid)
        try recentRef.setData(from: message)
        try recentRefII.setData(from: message)
        
        //Create connections
        let userRef = connectRef.document(uid).collection(Server.connections).document(message.fromId)
        let userIIRef = connectRef.document(message.fromId).collection(uid).document(uid)
        
        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            User.CodingKeys.username.rawValue: username ?? "",
            User.CodingKeys.imageUrl.rawValue: profileUrl ?? "",
            Message.CodingKeys.spotId.rawValue: message.spotId ?? "",
            User.CodingKeys.timestamp.rawValue: Timestamp()
        ]
        
        let dataII: [String: Any] = [
            User.CodingKeys.id.rawValue: message.fromId,
            User.CodingKeys.username.rawValue: message.displayName,
            User.CodingKeys.imageUrl.rawValue: message.ownerImageUrl,
            Message.CodingKeys.spotId.rawValue: message.spotId ?? "",
            Message.CodingKeys.spotName.rawValue: message.spotName ?? "",
            User.CodingKeys.timestamp.rawValue: Timestamp()
        ]
        
        try await userRef.setData(dataII)
        try await userIIRef.setData(data)
        
        //Set Location Connection
        let spotRef = connectRef.document(message.spotId ?? "").collection(Server.connections).document()
        
        let spotData: [String: Any] = [
            Message.CodingKeys.fromId.rawValue: message.fromId,
            Message.CodingKeys.toId.rawValue: uid,
            Message.CodingKeys.spotId.rawValue: message.spotId ?? "",
            Message.CodingKeys.spotName.rawValue: message.spotName ?? ""
        ]
        
        try await spotRef.setData(spotData)
    }
    
    
    //MARK: MESSAGE FUNCTIONS

    func getMessagesFor(userId: String, completion: @escaping (Result<[Message], Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var messages: [Message] = []
        chatListener = chatRef
                    .document(uid)
                    .collection(userId)
                    .addSnapshotListener({ snapshot, error in
    
                    if let error = error {
                        print("Error fetching messages for user")
                        completion(.failure(error))
                    }
    
                    snapshot?.documentChanges.forEach { change in
                        if change.type == .added {
                            let data = change.document.data()
                            let message = Message(data: data)
                            messages.append(message)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(messages))
                    }
        })
    }
    
    func removeChatListener() {
        chatListener?.remove()
        print("Removed Chat Listener")
    }
    
    func fetchRecentMessages(completion: @escaping (Result<[Message], Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var messages: [Message] = []
        
        recentMessageListener = chatRef
            .document(Server.recentMessage)
            .collection(uid)
            .addSnapshotListener({ querySnapshot, error in
                
                if let error = error {
                    print("Error Fetching Recent Messages", error.localizedDescription)
                    completion(.failure(error))
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let message = Message(data: data)
                        messages.insert(message, at: 0)
                    }
                })
                
                DispatchQueue.main.async {
                    completion(.success(messages))
                }
                
            })
    }
    
    func removeRecentListener() {
        recentMessageListener?.remove()
        print("Removed recent messages listener")
    }
    
    
    func sendMessage(userId: String, content: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let fromRef = chatRef.document(uid).collection(userId).document()
        let toRef = chatRef.document(userId).collection(uid).document()
        
        let data: [String: Any] = [
            Message.CodingKeys.id.rawValue: fromRef.documentID,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.toId.rawValue: userId,
            Message.CodingKeys.content.rawValue: content,
            Message.CodingKeys.timestamp.rawValue: Timestamp()
        ]
        
        try await toRef.setData(data)
        try await fromRef.setData(data)
        try await saveRecentMessgae(userId: userId, data: data)
    }
    
    func saveRecentMessgae(userId: String, data: [String: Any]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = chatRef.document(Server.recentMessage).collection(uid).document(userId)
        try await reference.setData(data)
    }
    
    func deleteRecentMessage(userId: String)  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        chatRef.document(Server.recentMessage).collection(uid).document(userId).delete()
    }
    
    
    
    
}
