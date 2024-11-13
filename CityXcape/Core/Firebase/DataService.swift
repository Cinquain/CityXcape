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
    var stampRef  = DB.collection(Server.stamps)
    
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
            Server.email: email ?? "",
            Message.CodingKeys.timestamp.rawValue: Timestamp(),
            User.CodingKeys.streetcred.rawValue: 1
        ]

        userRef.document(uid).setData(data)
        UserDefaults.standard.setValue(uid, forKey: CXUserDefaults.uid)
    }
    
    func createStreetPass(user: User) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = userRef.document(uid)
        try reference.setData(from: user.self)
        updateStreetCred(count: 1)
        UserDefaults.standard.setValue(user.username, forKey: CXUserDefaults.username)
        UserDefaults.standard.set(true, forKey: CXUserDefaults.createdSP)
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
    
    func getUserCredentials() async throws -> User {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        return try await getUserFrom(uid: uid)
    }

    func getUserFrom(uid: String) async throws -> User {
        let snapshot = try await userRef.document(uid).getDocument()
        let data = snapshot.data()
        let user = User(data: data)
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
    
    
    
    //MARK: CHECKIN FUNCTIONS
    func fetchUsersCheckedIn(spotId: String, completion: @escaping(Result<[User],Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var users: [User] = []
        
        checkinListener = spotRef.document(spotId)
                         .collection(Server.checkins)
                         .addSnapshotListener({ snapshot, error in
                             
                             if let error = error {
                                 print("Error fetching checked-in users")
                                 completion(.failure(error))
                             }
                             guard let snapshot = snapshot else {return}
                             
                             for change in snapshot.documentChanges {
                                 
                                 if change.document.documentID == uid {
                                     continue
                                 }
                                 
                                 if change.type == .added {
                                     let data = change.document.data()
                                     let user = User(data: data)
                                     users.insert(user, at: 0)
                                 }
                                 
                                 if change.type == .removed {
                                     let id = change.document.documentID
                                     if let index = users.firstIndex(where: {$0.id == id}) {
                                         users.remove(at: index)
                                     }
                                 }
                             }
                             
                             DispatchQueue.main.async {
                                 completion(.success(users))
                             }
                             
                         })

    }
    
    func checkin(spotId: String, user: User) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = spotRef.document(spotId).collection(Server.checkins)
        try reference.document(uid).setData(from: user.self)
    }
    
    func checkout(spotId: String) async throws  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = spotRef.document(spotId).collection(Server.checkins).document(uid)
        checkinListener?.remove()
        try await reference.delete()
    }
    
    //MARK: STREETCRED FUNCTIONS
    
    func updateStreetCred(count: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let value = Double(count)
        let reference = userRef.document(uid)
        let data: [String: Any] = [
            User.CodingKeys.streetcred.rawValue: FieldValue.increment(value)
        ]
        reference.updateData(data)
        UserDefaults.standard.setValue(count, forKey: CXUserDefaults.streetcred)
    }
    
    func getStreetCred() async throws -> Int  {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        let reference = userRef.document(uid)
        let document = try await reference.getDocument()
        guard let data = document.data() else {return 0}
        let user = User(data: data)
        print("StreetCred is \(user.streetcred)")
        UserDefaults.standard.setValue(user.streetcred, forKey: CXUserDefaults.streetcred)
        return user.streetcred
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
    
    func getWorldFor(id: String) async throws -> World {
        let reference = worldRef.document(id)
        let world = try await reference.getDocument(as: World.self)
        return world
    }
    
    func saveUserWorld(worldId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        let reference = userRef.document(uid)
        try await saveMemberToWorld(worldId: worldId)
        let data: [String: Any] = [
            User.CodingKeys.worlds.rawValue: FieldValue.arrayUnion([worldId])
        ]
        try await reference.setData(data, merge: true)
        
    }
    
    func deleteWorld(worldId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = userRef.document(uid)
        let data: [String: Any] = [
            User.CodingKeys.worlds.rawValue: FieldValue.arrayRemove([worldId])
        ]
        try await reference.setData(data, merge: true)
        try await worldRef.document(worldId).collection(Server.members).document(uid).delete()
    }
    
     
    func saveMemberToWorld(worldId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        let reference = worldRef.document(worldId).collection(Server.members)
        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            Message.CodingKeys.timestamp.rawValue: FieldValue.serverTimestamp()
        ]
        try await reference.document(uid).setData(data)
    }

    //MARK: CONNECTION FUNCTIONS
    func sendRequest(userId: String, spotId: String, message: String) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        let imageUrl = profileUrl ?? ""
        let username = username ?? ""
        
        let reference = userRef.document(userId)
                                  .collection(Server.request)
                                  .document(uid)
        
        let spotReference = spotRef.document(spotId).collection(Server.request).document()
        
        let data: [String: Any] = [
            Message.CodingKeys.id.rawValue: reference.documentID,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.toId.rawValue: userId,
            Message.CodingKeys.content.rawValue: message,
            Message.CodingKeys.timestamp.rawValue: Timestamp(),
            Message.CodingKeys.ownerImageUrl.rawValue: imageUrl,
            Message.CodingKeys.displayName.rawValue: username,
            Message.CodingKeys.spotId.rawValue: spotId
        ]
        
        
        
        try await reference.setData(data)
        updateStreetCred(count: -1)
        try await spotReference.setData(data)
    }
    
    func acceptRequest(message: Message) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        
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
        let userIRef = userRef.document(uid).collection(Server.connections).document(message.fromId)
        let userIIRef = userRef.document(message.fromId).collection(uid).document(uid)
        
        //Set Location Connection
        let spotRef = connectRef.document(message.spotId ?? "").collection(Server.connections).document()
        
        let spotData: [String: Any] = [
            Message.CodingKeys.fromId.rawValue: message.fromId,
            Message.CodingKeys.toId.rawValue: uid,
            Message.CodingKeys.timestamp.rawValue: Timestamp(),
        ]
        
        try await spotRef.setData(spotData)
    }
    
    func fetchAllRequests() async throws -> [Request] {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        var requests: [Request] = []
        let reference = userRef.document(uid).collection(Server.request)
        
        let documents = try await reference.getDocuments()
        
        documents.documents.forEach { snapshot in
            let data = snapshot.data()
            let request = Request(data: data)
            requests.append(request)
        }
        return requests
    }
    
    
    func deleteConnection(userId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let reference = userRef.document(uid).collection(Server.connections).document(userId)
        let referenceII = userRef.document(userId).collection(Server.connections).document(uid)
        try await reference.delete()
        try await referenceII.delete()
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
    
    
    //MARK: STAMP FUNCTIONS
    
    func fetchAllStamps() async throws -> [Stamp] {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        var stamps : [Stamp] = []
        
        let reference = userRef.document(uid).collection(Server.stamps)
        let documents = try await reference.getDocuments()
        
        for snapshot in documents.documents {
            let data = snapshot.data()
            let stamp = Stamp(data: data)
            stamps.append(stamp)
        }
        return stamps
    }
    
    func createStamp(spot: Location) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = userRef.document(uid).collection(Server.stamps).document(spot.id)
        
        let data: [String : Any] = [
            Stamp.CodingKeys.id.rawValue: spot.id,
            Stamp.CodingKeys.imageUrl.rawValue: spot.imageUrl,
            Stamp.CodingKeys.ownerId.rawValue: uid,
            Stamp.CodingKeys.city.rawValue: spot.city,
            Stamp.CodingKeys.timestamp.rawValue: FieldValue.serverTimestamp(),
            Stamp.CodingKeys.spotName.rawValue: spot.name
        ]
        
        try await reference.setData(data)
    }
    
    func updateStampImage(stampId: String, imageUrl: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = userRef.document(uid).collection(Server.stamps).document(stampId)
        
        let data: [String: Any] = [
            Stamp.CodingKeys.imageUrl.rawValue: imageUrl
        ]
        
        try await reference.updateData(data)
    }
    
    
    
    
}
