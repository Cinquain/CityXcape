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
    @Published var isCheckedIn = true
    
    var usersBranch = DB.collection(Server.users)
    var locationsBranch = DB.collection(Server.locations)
    var messagesBranch = DB.collection(Server.messages)
    var worldBranch = DB.collection(Server.world)
    var salesBranch = DB.collection(Server.sales)
    
    var chatListener: ListenerRegistration?
    var checkinListener: ListenerRegistration?
    var recentMessageListener: ListenerRegistration?
    var requestListener: ListenerRegistration?
    
    @AppStorage(CXUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(CXUserDefaults.username) var username: String?
    @AppStorage(CXUserDefaults.fcmToken) var fcmToken: String?
    @AppStorage(CXUserDefaults.lastSpotId) var lastSpotId: String?



    
    //MARK: AUTH FUNCTIONS
    func createUser(auth: AuthDataResult) {
        let uid = auth.user.uid
        let email = auth.user.email
        
        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            Server.email: email ?? "",
            Server.fcmToken: fcmToken ?? "",
            Server.timestamp: Timestamp(),
            User.CodingKeys.streetcred.rawValue: 1
        ]

        usersBranch.document(uid).setData(data)
        UserDefaults.standard.setValue(uid, forKey: CXUserDefaults.uid)
    }
        
    func loginUser(uid: String) async throws {
        let user = try await getUserFrom(uid: uid)
        AnalyticService.shared.loginUser()
        setUserDefaults(user: user)
    }
    
    func createUserName(name: String, gender: Bool) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = usersBranch.document(uid)
        let value: Double = 1
        let data: [String: Any] = [
            User.CodingKeys.username.rawValue: name,
            User.CodingKeys.gender.rawValue: gender,
            User.CodingKeys.streetcred.rawValue: FieldValue.increment(value)

        ]
        try await reference.updateData(data)
        UserDefaults.standard.setValue(name, forKey: CXUserDefaults.username)
    }
    
    func saveUserCity(city: String)  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = usersBranch.document(uid)
        let data: [String: Any] = [
            User.CodingKeys.city.rawValue: city,
        ]
        reference.updateData(data)
    }
    
    func setUserDefaults(user: User) {
        UserDefaults.standard.set(user.id, forKey: CXUserDefaults.uid)
        UserDefaults.standard.setValue(user.imageUrl, forKey: CXUserDefaults.profileUrl)
        UserDefaults.standard.setValue(user.username, forKey: CXUserDefaults.username)
    }
    
    
    //MARK: USER FUNCTIONS
    func checkIfUserExist(uid: String) async throws -> Bool {
        if try await usersBranch.document(uid).getDocument().exists {
            try await loginUser(uid: uid)
            return true
        } else {
            return false
        }
    }
    
    func getUserCredentials() async throws -> User {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        let user = try await getUserFrom(uid: uid)
        setUserDefaults(user: user)
        return user
    }

    func getUserFrom(uid: String) async throws -> User {
        let snapshot = try await usersBranch.document(uid).getDocument()
        let data = snapshot.data()
        let user = User(data: data)
        return user
    }
   
    func uploadImageUrl(uid: String, url: String) async throws {
        let data: [String: Any] = [
            User.CodingKeys.imageUrl.rawValue: url,
        ]
        let ref = usersBranch.document(uid)
        try await ref.updateData(data)
    }
    
    func updateFcmToken(fcm: String) {
        UserDefaults.standard.set(fcm, forKey: CXUserDefaults.fcmToken)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let data: [String: Any] = [
            Server.fcmToken: fcm
        ]
        let reference = usersBranch.document(uid)
        reference.updateData(data)
    }
    
    func saveUserWorlds(worlds: [World]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var values: [String: [String: Any]] = [:]
        let value: Double = 1
        let reference = usersBranch.document(uid)
        for world in worlds {
            values[world.id] = [
                World.CodingKeys.id.rawValue: world.id,
                World.CodingKeys.name.rawValue: world.name,
                World.CodingKeys.memberName.rawValue: world.memberName,
                World.CodingKeys.imageUrl.rawValue: world.imageUrl,
            ]
           
            try await saveMemberToWorld(worldId: world.id)
        }
        
        let data: [String: Any] = [
            User.CodingKeys.worlds.rawValue: values,
            User.CodingKeys.streetcred.rawValue: FieldValue.increment(value)
        ]
        try await reference.updateData(data)
    }
    
    
    func deleteUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        try await usersBranch.document(uid).delete()
        try await Auth.auth().currentUser?.delete()
        try AuthService.shared.signOut()
    }
    
    
    
    //MARK: CHECKIN FUNCTIONS
    func fetchUsersCheckedIn(spotId: String, completion: @escaping(Result<[User],Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var users: [User] = []
        
        checkinListener = locationsBranch.document(spotId)
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
                                     let user = try? change.document.data(as: User.self)
                                     guard let user = user else {return}
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
        let reference = locationsBranch.document(spotId).collection(Server.checkins)
        print("User id is \(user.id)")
        try reference.document(user.id).setData(from: user.self)
        let expiresAt = Timestamp(date: Date().addingTimeInterval(2 * 60 * 60))
        let timeData: [String: Any] = [
            Server.expiresAt : expiresAt
        ]
        try await reference.document(user.id).updateData(timeData)
        
        let count: Double = 1
        let data: [String: Any] = [
            Location.CodingKeys.checkinCount.rawValue: FieldValue.increment(count)
        ]
        UserDefaults.standard.set(true, forKey: CXUserDefaults.isCheckedIn)
        try await locationsBranch.document(spotId).updateData(data)
    }
    
   
    
    func checkout(spotId: String) async throws  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = locationsBranch.document(spotId).collection(Server.checkins).document(uid)
        checkinListener?.remove()
        try await reference.delete()
        AnalyticService.shared.checkout()
    }
    
    //MARK: STREETCRED FUNCTIONS
    
    func updateStreetCred(count: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let value = Double(count)
        let reference = usersBranch.document(uid)
        let data: [String: Any] = [
            User.CodingKeys.streetcred.rawValue: FieldValue.increment(value)
        ]
        reference.updateData(data)
        UserDefaults.standard.setValue(count, forKey: CXUserDefaults.streetcred)
    }
    
    func purchaseStreetCredForHub(spot: Location, count: Int, price: Double) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        //Update User StreetCred
        updateStreetCred(count: count)
        
        //Update location sales
        let reference = locationsBranch.document(spot.id).collection(Server.sales).document()
        let locationSale: Double = price * 0.30

      
        
        let locationRecord: [String: Any] = [
            User.CodingKeys.id.rawValue: reference.documentID,
            Server.userId: uid,
            User.CodingKeys.username.rawValue: username ?? "",
            User.CodingKeys.imageUrl.rawValue: profileUrl ?? "",
            User.CodingKeys.streetcred.rawValue: count,
            Server.commission: locationSale,
            Server.sale: price,
            Server.timestamp: FieldValue.serverTimestamp()
        ]
        reference.setData(locationRecord)
        
        //Update Scoutstats
        AnalyticService.shared.purchasedSTC()
    }
    
    func purchaseStreetCredForHunt(spot: Location, count:  Int, price: Double) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        updateStreetCred(count: count)
        let scoutSale: Double = price * 0.50
        let locationReference = locationsBranch.document(spot.id).collection(Server.sales).document()
        let scoutReference = salesBranch.document(spot.ownerId).collection(spot.id).document()
        
       
        
       
        let locationRecord: [String: Any] = [
            User.CodingKeys.id.rawValue: locationReference.documentID,
            Server.userId: uid,
            User.CodingKeys.username.rawValue: username ?? "",
            User.CodingKeys.imageUrl.rawValue: profileUrl ?? "",
            User.CodingKeys.streetcred.rawValue: count,
            Server.sale: price,
            Server.commission: scoutSale,
            Server.timestamp: FieldValue.serverTimestamp()
        ]
        
        scoutReference.setData(locationRecord)
        locationReference.setData(locationRecord)
        
    }
    
  
    
    
    
    func getStreetCred() async throws -> Int  {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        let reference = usersBranch.document(uid)
        let document = try await reference.getDocument()
        guard let data = document.data() else {return 0}
        let user = User(data: data)
        print("StreetCred is \(user.streetcred)")
        UserDefaults.standard.setValue(user.streetcred, forKey: CXUserDefaults.streetcred)
        return user.streetcred
    }
    
    //MARK: LOCATION FUNCTIONS
    func getSpotFrom(id: String) async throws -> Location {
        let snapshot = try await locationsBranch.document(id).getDocument()
        let location = try snapshot.data(as: Location.self)
        print("Got Location Successfully")
        return location
    }
    
    //MARK: WORLD FUNCTIONS
    func fetchAllWorlds() async throws -> [World] {
        var worlds: [World] = []
        let snapshot = try await worldBranch.getDocuments()
        snapshot.documents.forEach { document in
            let data = document.data()
            let world = World(data: data)
            worlds.append(world)
        }
        return worlds
    }
    
   
    
    func getWorldFor(id: String) async throws -> World {
        let reference = worldBranch.document(id)
        let world = try await reference.getDocument(as: World.self)
        return world
    }
    
    func deleteWorld(worldId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = usersBranch.document(uid)
        let data: [String: Any] = [
            User.CodingKeys.worlds.rawValue: FieldValue.arrayRemove([worldId])
        ]
        try await reference.setData(data, merge: true)
        try await worldBranch.document(worldId).collection(Server.members).document(uid).delete()
    }
    
     
    func saveMemberToWorld(worldId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        let reference = worldBranch.document(worldId).collection(Server.members)
        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            Server.timestamp: FieldValue.serverTimestamp()
        ]
        try await reference.document(uid).setData(data)
    }

    //MARK: CONNECTION FUNCTIONS
    func sendRequest(userId: String, request: Request) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        
        let reference = usersBranch.document(userId).collection(Server.request).document(uid)
        
        try reference.setData(from: request.self)
        updateStreetCred(count: -1)
    }
    
    func removeRequest(request: Request) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = usersBranch.document(uid).collection(Server.request).document(request.id)
        try await reference.delete()
        AnalyticService.shared.deniedRequest()
    }
    
    func acceptRequest(content: String, request: Request) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        
        try await createInitialChat(userId: request.id, request: request)
        //Create chat references
        let messageRef = messagesBranch.document(uid).collection(request.id).document()
        let messageRefII = messagesBranch.document(request.id).collection(uid).document()
        let requestRef = usersBranch.document(uid).collection(Server.request).document(request.id)
        //Create recent message references
        let recentRefII = messagesBranch.document(Server.recentMessage).collection(request.id).document(uid)
        
        let message: [String: Any] = [
            Message.CodingKeys.id.rawValue: messageRef.documentID,
            Message.CodingKeys.imageUrl.rawValue: profileUrl ?? "",
            Message.CodingKeys.username.rawValue: username ?? "",
            Message.CodingKeys.content.rawValue: content,
            Message.CodingKeys.toId.rawValue: request.id,
            Message.CodingKeys.fromId.rawValue: uid
        ]
        
        try await messageRef.setData(message)
        try await messageRefII.setData(message)
        try await recentRefII.setData(message)
        try await requestRef.delete()
        //Create connections
        try await createConnections(userId: request.id, spotId: request.spotId)
        try await usersBranch.document(uid).collection(Server.request).document(request.id).delete()
    }
    
    func createInitialChat(userId: String, request: Request) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let reference = messagesBranch.document(uid).collection(userId).document()
        let referenceII = messagesBranch.document(userId).collection(uid).document()
        let referenceIII = messagesBranch.document(Server.recentMessage).collection(uid).document(userId)
        let message: [String: Any] = [
            Message.CodingKeys.id.rawValue: reference.documentID,
            Message.CodingKeys.fromId.rawValue: request.id,
            Message.CodingKeys.toId.rawValue: uid,
            Message.CodingKeys.content.rawValue: request.content,
            Message.CodingKeys.imageUrl.rawValue: request.imageUrl,
            Message.CodingKeys.username.rawValue: request.username
        ]
        
        try await reference.setData(message)
        try await referenceII.setData(message)
        try await referenceIII.setData(message)
    }
    
    func createConnections(userId: String, spotId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let reference = usersBranch.document(uid).collection(Server.connections).document(userId)
        let referenceII = usersBranch.document(userId).collection(Server.connections).document(uid)
        let spotRef = locationsBranch.document(spotId).collection(Server.connections).document()

        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: userId,
            Request.CodingKeys.spotId.rawValue: spotId,
            Server.timestamp: FieldValue.serverTimestamp()
        ]
        
        let dataII: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            Request.CodingKeys.spotId.rawValue: spotId,
            Server.timestamp: FieldValue.serverTimestamp()
        ]
        
        let spotData: [String: Any] = [
            Message.CodingKeys.fromId.rawValue: userId,
            Message.CodingKeys.toId.rawValue: uid,
            Request.CodingKeys.spotId.rawValue: spotId,
            Server.timestamp: FieldValue.serverTimestamp(),
        ]
        
        
        try await reference.setData(data)
        try await referenceII.setData(dataII)
        try await spotRef.setData(spotData)
        AnalyticService.shared.newConnection()
    }
    
    func fetchAllRequests() async throws -> [Request] {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        var requests: [Request] = []
        let reference = usersBranch.document(uid).collection(Server.request)
        
        let documents = try await reference.getDocuments()
        
        documents.documents.forEach { snapshot in
            let data = snapshot.data()
            let request = Request(data: data)
            requests.append(request)
        }
        return requests
    }
    
    func startListeningtoRequest(completion: @escaping (Result<[Request], Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var requests: [Request] = []
        
        recentMessageListener = usersBranch
            .document(uid)
            .collection(Server.request)
            .addSnapshotListener({ querySnapshot, error in
                
                if let error = error {
                    print("Error Fetching Recent Messages", error.localizedDescription)
                    completion(.failure(error))
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let request = Request(data: data)
                        requests.insert(request, at: 0)
                    }
                })
                
                DispatchQueue.main.async {
                    completion(.success(requests))
                }
                
            })
    }
    
    func removeRequestListener() {
        requestListener?.remove()
        print("Removed recent messages listener")
    }
    
    
    func deleteConnection(userId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let reference = usersBranch.document(uid).collection(Server.connections).document(userId)
        let referenceII = usersBranch.document(userId).collection(Server.connections).document(uid)
        try await reference.delete()
        try await referenceII.delete()
    }
    
    
    //MARK: MESSAGE FUNCTIONS

    func getMessagesFor(userId: String, completion: @escaping (Result<[Message], Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        updateRecentMessage(userId: userId)
        var messages: [Message] = []
        chatListener = messagesBranch
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
        
        recentMessageListener = messagesBranch
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
        let fromRef = messagesBranch.document(uid).collection(userId).document()
        let toRef = messagesBranch.document(userId).collection(uid).document()
        
        let data: [String: Any] = [
            Message.CodingKeys.id.rawValue: fromRef.documentID,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.toId.rawValue: userId,
            Message.CodingKeys.imageUrl.rawValue: profileUrl ?? "",
            Message.CodingKeys.username.rawValue: username ?? "",
            Message.CodingKeys.content.rawValue: content,
            Message.CodingKeys.read.rawValue: false,
            Server.timestamp: Timestamp()
        ]
        
        try await toRef.setData(data)
        try await fromRef.setData(data)
        try await saveRecentMessgae(userId: userId, data: data)
        AnalyticService.shared.sentMessage()
    }
    
    func saveRecentMessgae(userId: String, data: [String: Any]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = messagesBranch.document(Server.recentMessage).collection(userId).document(uid)
        try await reference.delete()
        try await reference.setData(data)
    }
    
    func updateRecentMessage(userId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = messagesBranch.document(Server.recentMessage).collection(uid).document(userId)
        
        let data: [String: Any] = [
            Message.CodingKeys.read.rawValue: true
        ]
        reference.updateData(data)
    }
    
    func deleteRecentMessage(userId: String)  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        messagesBranch.document(Server.recentMessage).collection(uid).document(userId).delete()
    }
    
    
    //MARK: STAMP FUNCTIONS
    
    func fetchAllStamps() async throws -> [Stamp] {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.authFailure}
        var stamps : [Stamp] = []
        
        let reference = usersBranch.document(uid).collection(Server.stamps)
        let documents = try await reference.getDocuments()
        
        for snapshot in documents.documents {
            let data = snapshot.data()
            let stamp = Stamp(data: data)
            stamps.append(stamp)
        }
        return stamps
    }
    
    func createStamp(spot: Location, username: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = usersBranch.document(uid).collection(Server.stamps).document(spot.id)
        let referenceII = locationsBranch.document(spot.id).collection(Server.stamps).document(uid)
        let data: [String : Any] = [
            Stamp.CodingKeys.id.rawValue: spot.id,
            Stamp.CodingKeys.imageUrl.rawValue: spot.imageUrl,
            Stamp.CodingKeys.ownerId.rawValue: uid,
            Stamp.CodingKeys.city.rawValue: spot.city,
            Stamp.CodingKeys.timestamp.rawValue: FieldValue.serverTimestamp(),
            Stamp.CodingKeys.spotName.rawValue: spot.name
        ]
        
        let dataII: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            User.CodingKeys.username.rawValue: username,
            Stamp.CodingKeys.ownerId.rawValue: spot.ownerId,
            Stamp.CodingKeys.spotName.rawValue: spot.name,
            Server.timestamp: FieldValue.serverTimestamp()
        ]
        
        try await reference.setData(data)
        try await referenceII.setData(dataII)
        AnalyticService.shared.newStamp()
    }
    
    func updateStampImage(stampId: String, imageUrl: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let reference = usersBranch.document(uid).collection(Server.stamps).document(stampId)
        
        let data: [String: Any] = [
            Stamp.CodingKeys.imageUrl.rawValue: imageUrl
        ]
        
        try await reference.updateData(data)
    }
    
   
    
}
