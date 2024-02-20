//
//  DataService.swift
//  CityXcape
//
//  Created by James Allan on 8/9/23.
//

import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift
import MapKit
import SwiftUI

let DB = Firestore.firestore()

final class DataService {
    
    //MARK: USER DEFAULTS
    @AppStorage(AppUserDefaults.streetcred) var streetcred: Int?
    @AppStorage(AppUserDefaults.username) var username: String?
    @AppStorage(AppUserDefaults.uid) var uid: String?
    @AppStorage(AppUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(AppUserDefaults.location) var locationName: String?
    @AppStorage(AppUserDefaults.spotId) var locationId: String?


    static let shared = DataService()
    private init() {}
    
    //MARK: DATABASE REFERENCES
    var usersRef = DB.collection(Server.users)
    var locationsRef = DB.collection(Server.locations)
    var privatesRef = DB.collection(Server.privates)
    var worldRef = DB.collection(Server.worlds)
    var messageRef = DB.collection(Server.messages)

    var chatListener: ListenerRegistration?
    var recentMessageListener: ListenerRegistration?
    var checkinListener: ListenerRegistration?
    var requestListener: ListenerRegistration?
    
    
    //MARK: LOCATION FUNCTIONS
    func getSpotFromId(id: String) async throws -> Location {
        let referene = locationsRef.document(id)
        let snapshot = try await referene.getDocument()
        guard let data = snapshot.data() else {throw CustomError.badData}
        return Location(data: data)
    }
    
    func getSpotsFromIds(ids: [String]) async throws -> [Location]{
        var locations: [Location] = []
        for id in ids {
            let location = try await getSpotFromId(id: id)
            locations.append(location)
        }
        return locations
    }
    
    func fetchAllLocations() async throws -> [Location] {
        let ref = locationsRef
        var locations: [Location] = []
        let snapshot = try await ref.limit(to: 50).getDocuments()
        
         snapshot.documents.forEach {
            let location = Location(data:  $0.data())
            locations.append(location)
        }
            return locations
    }
    
    func createLocation(name: String, description: String, longitude: Double,
                        latitude: Double, address: String, city: String, image: UIImage,
                        extraI: UIImage?, extraII: UIImage?) async throws {
        
        let spotRef = locationsRef.document()
        let spotId = spotRef.documentID
        let increment: Double = 1
        
        let userId = Auth.auth().currentUser?.uid ?? ""
        let userRef = usersRef.document(userId)
        let userRecordsRef = privatesRef.document(userId).collection(Server.uploads).document(spotId)
    
        let streetcredData: [String: Any] = [
            User.CodingKeys.streetCred.rawValue: FieldValue.increment(increment),
            User.CodingKeys.spotsFound.rawValue: FieldValue.increment(Double(1))
        ]
        let personalData: [String: Any] = [
            Location.CodingKeys.id.rawValue: spotId,
            Location.CodingKeys.timestamp.rawValue: Timestamp()
        ]
        
        let imageUrl = try await ImageManager.shared.uploadLocationImage(id: spotId, image: image)
        
        let data: [String: Any] = [
            Location.CodingKeys.id.rawValue: spotId,
            Location.CodingKeys.name.rawValue: name,
            Location.CodingKeys.description.rawValue: description,
            Location.CodingKeys.imageUrl.rawValue : imageUrl,
            Location.CodingKeys.longitude.rawValue: longitude,
            Location.CodingKeys.latitude.rawValue: latitude,
            Location.CodingKeys.address.rawValue: address,
            Location.CodingKeys.city.rawValue: city,
            Location.CodingKeys.ownerId.rawValue: userId,
            Location.CodingKeys.ownerImageUrl.rawValue: profileUrl ?? "",
            Location.CodingKeys.ownerUsername.rawValue: username ?? "",
        ]
        
        try await spotRef.setData(data)
        try await userRef.updateData(streetcredData)
        try await userRecordsRef.setData(personalData)
        
        guard let addedImage = extraI else {return}
        let extraImageUrl = try await ImageManager.shared.uploadLocationExtraImage(id: spotId, image: addedImage)
        let extraData: [String: Any] = [Location.CodingKeys.extraImages.rawValue: FieldValue.arrayUnion([extraImageUrl])]
        try await spotRef.updateData(extraData)
        
        guard let extraddedImage = extraII else {return}
        let extraImageUrlII = try await ImageManager.shared.uploadLocationExtraImage(id: spotId, image: extraddedImage)
        let extraDataII: [String: Any] = [Location.CodingKeys.extraImages.rawValue: FieldValue.arrayUnion([extraImageUrlII])]
        try await spotRef.updateData(extraDataII)
    }
    
    func updateViewCount(spotId: String) async throws {
        let spotRef = locationsRef.document(spotId)
        let data: [String: Any] = [
            Location.CodingKeys.viewCount.rawValue: FieldValue.increment(Double(1))
        ]
        try await spotRef.updateData(data)
    }
    
    func updateTitle(spotId: String, title: String) async throws {
        let spotRef = locationsRef.document(spotId)
        let data: [String: Any] = [
            Location.CodingKeys.name.rawValue: title
        ]
        try await spotRef.updateData(data)
    }
    
    func updateDetail(spotId: String, detail: String) async throws {
        let spotRef = locationsRef.document(spotId)
        let data: [String: Any] = [
            Location.CodingKeys.description.rawValue: detail
        ]
        try await spotRef.updateData(data)
    }
    
    func updateLatitude(spotId: String, latitude: String) async throws {
        let spotRef = locationsRef.document(spotId)
        let lat = Double(latitude)
        let data: [String: Any] = [
            Location.CodingKeys.latitude.rawValue: lat ?? 0
        ]
        try await spotRef.updateData(data)
    }
    
    func updateLongitude(spotId: String, longitude: String) async throws {
        let spotRef = locationsRef.document(spotId)
        let long = Double(longitude)
        let data: [String: Any] = [
            Location.CodingKeys.longitude.rawValue: long ?? 0
        ]
        try await spotRef.updateData(data)
    }
    
    func updateLiveCount(spotId: String, increment: Double) async throws {
        let spotRef = locationsRef.document(spotId)
        let data: [String: Any] = [
            Location.CodingKeys.liveCount.rawValue: FieldValue.increment(increment)
        ]
        try await spotRef.updateData(data)
    }
    
    func updateCheckinCount(spotId: String) async throws {
        let spotRef = locationsRef.document(spotId)
        let increment: Double = 1
        let data: [String: Any] = [
            Location.CodingKeys.checkinCount.rawValue: FieldValue.increment(increment)
        ]
        try await spotRef.updateData(data)
    }
    
    func updateSpotImageUrl(spotId: String, imageUrl: String) async throws {
        let spotRef = locationsRef.document(spotId)
        let data: [String: Any] = [
            Location.CodingKeys.imageUrl.rawValue: imageUrl
        ]
        try await spotRef.updateData(data)
    }
    
    func updateSpotExtraImage(spotId: String, imageUrl: String) async throws {
        let spotref = locationsRef.document(spotId)
        let data: [String: Any] = [
            Location.CodingKeys.extraImages.rawValue: FieldValue.arrayUnion([imageUrl])
        ]
        try await spotref.updateData(data)
    }
    
    func deleteSpotExtraImage(spotId: String, imageurl: String) async throws {
        let spotRef = locationsRef.document(spotId)
        let url = URL(string: imageurl)
        if let imageName = url?.pathComponents.last {
            try await ImageManager.shared.deleteExtraImage(spotId: spotId, imageName: imageName)
        }
        let data: [String: Any] = [
            Location.CodingKeys.extraImages.rawValue: FieldValue.arrayRemove([imageurl])
        ]
        try await spotRef.updateData(data)
    }
    
    func deleteLocation(spotId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.uidNotFound}
        let spotRef = locationsRef.document(spotId)
        let userRef = usersRef.document(uid)
        let privateRef = privatesRef.document(uid)
        let data: [String: Any] = [
            User.CodingKeys.spotsFound.rawValue: FieldValue.increment(Double(-1))
        ]
        
        try await spotRef.delete()
        try await userRef.updateData(data)
        
        //DELETE LIKE
        let userLike = privateRef.collection(Server.likes).document(spotId)
        if try await userLike.getDocument().exists {
            try await userLike.delete()
        }
        //DELETE STAMP
        let userStamp = privateRef.collection(Server.stamps).document(spotId)
        if try await userStamp.getDocument().exists {
            try await userStamp.delete()
        }
        //DELETE ANALYTICS
        let userUploads = privateRef.collection(Server.uploads).document(spotId)
        try await userUploads.delete()
    }
    
    func saveOrUnsaveLocation(spot: Location) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let increment: Double = 1

        let userData: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            Location.CodingKeys.timestamp.rawValue: Timestamp(),
            User.CodingKeys.username.rawValue: username ?? "",
            User.CodingKeys.imageUrl.rawValue: profileUrl ?? ""
        ]
        
        let spotData: [String: Any] = [
            Location.CodingKeys.id.rawValue: spot.id,
            Location.CodingKeys.name.rawValue: spot.name,
            Location.CodingKeys.longitude.rawValue: spot.longitude,
            Location.CodingKeys.latitude.rawValue: spot.latitude,
            Location.CodingKeys.imageUrl.rawValue: spot.imageUrl,
            Location.CodingKeys.timestamp.rawValue: Timestamp()
        ]
        
        let countData: [String: Any] = [
            Location.CodingKeys.saveCount.rawValue: FieldValue.increment(increment)
        ]
        
        let userSavesRef = privatesRef
                                .document(uid)
                                .collection(Server.saves)
                                .document(spot.id)
        let spotsRef = locationsRef.document(spot.id)
        
        if try await spotsRef.collection(Server.saves).document(uid).getDocument().exists {
            try await unsaveLocation(spotId: spot.id)
        } else {
            try await spotsRef.updateData(countData)
            try await userSavesRef.setData(spotData)
            try await spotsRef.collection(Server.saves).document(uid).setData(userData)
            Analytic.shared.savedLocation()
        }
    }
    
    func unsaveLocation(spotId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let increment: Double = -1
        
        let data: [String: Any] = [
            Location.CodingKeys.saveCount.rawValue: FieldValue.increment(increment)
        ]
        
        let userSavesRef = privatesRef
                                .document(uid)
                                .collection(Server.saves)
                                .document(spotId)
        let spotsRef = locationsRef.document(spotId)
        
        try await spotsRef.updateData(data)
        try await userSavesRef.delete()
        try await spotsRef.collection(Server.saves).document(uid).delete()
    }
    
    func fetchBucketlist() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.uidNotFound}
        let reference = privatesRef.document(uid).collection(Server.saves)
        let snapshot = try await reference.getDocuments()
        let ids = snapshot.documents.map({$0.documentID})
        return ids
    }
    
    func fetchUserUploads() async throws -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.uidNotFound}
        let uploadsRef = privatesRef.document(uid).collection(Server.uploads)
        let snapshot = try await uploadsRef.getDocuments()
        let ids = snapshot.documents.map({$0.documentID})
        return ids
    }
    
    func likeOrUnlike(spot: Location) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let increment: Double = 1
        let data: [String: Any] = [
            Location.CodingKeys.likeCount.rawValue: FieldValue.increment(increment)
        ]
        let spotRef = locationsRef.document(spot.id)
        
        if try await spotRef.collection(Server.likes).document(uid).getDocument().exists {
            try await dislike(spot: spot)
        } else {
            let userLikesRef = privatesRef
                                    .document(uid)
                                    .collection(Server.likes)
                                    .document(spot.id)
            let likeData: [String: Any] = [
                User.CodingKeys.id.rawValue: uid,
                User.CodingKeys.timestamp.rawValue: Timestamp(),
                User.CodingKeys.username.rawValue: username ?? "",
                User.CodingKeys.imageUrl.rawValue: profileUrl ?? ""
            ]
            let spotData: [String: Any] = [
                Location.CodingKeys.id.rawValue: spot.id,
                Location.CodingKeys.name.rawValue: spot.name,
                Location.CodingKeys.timestamp.rawValue: Timestamp()
            ]
            try await spotRef.updateData(data)
            try await userLikesRef.setData(spotData)
            try await spotRef.collection(Server.likes).document(uid).setData(likeData)
            Analytic.shared.likedLocation()
        }
    }
    
    func dislike(spot: Location) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let increment: Double = -1
        let spotRef = locationsRef.document(spot.id)
        let userLikesRef = privatesRef
                                .document(uid)
                                .collection(Server.likes)
                                .document(spot.id)

        let data: [String: Any] = [
            Location.CodingKeys.likeCount.rawValue: FieldValue.increment(increment)
        ]
        try await spotRef.updateData(data)
        try await spotRef.collection(Server.likes).document(uid).delete()
        try await userLikesRef.delete()
    }
    
    //MARK: STAMP FUNCTIONS
    
    func checkinLocation(spot: Location) async throws {
        let spotRef = locationsRef.document(spot.id)
        guard let uid = Auth.auth().currentUser?.uid else {return}
       
        let userStampsCollectionRef = privatesRef.document(uid).collection(Server.stamps).document(spot.id)
        let spotHistoryRef = spotRef.collection(Server.history).document(uid)
        
        //Save the stamp to user stamp archives
        let data: [String: Any] = [
            Stamp.CodingKeys.id.rawValue: spot.id,
            Stamp.CodingKeys.spotName.rawValue: spot.name,
            Stamp.CodingKeys.ownerId.rawValue: uid,
            Stamp.CodingKeys.latitude.rawValue: spot.latitude,
            Stamp.CodingKeys.longitude.rawValue: spot.longitude,
            Stamp.CodingKeys.timestamp.rawValue: Timestamp(),
            Stamp.CodingKeys.imageUrl.rawValue: spot.imageUrl,
            Stamp.CodingKeys.city.rawValue: spot.city,
            Stamp.CodingKeys.ownerImageUrl.rawValue: profileUrl ?? "",
            Stamp.CodingKeys.displayName.rawValue: username ?? ""
        ]
        
            
        //Adds the location to user collection if it does not exist
        if try await !userStampsCollectionRef.getDocument().exists {
            try await userStampsCollectionRef.setData(data)
            try await updateStreetCred(counter: 5)
            Analytic.shared.newStamp()
        }
        //Adds it to check in history of location if it's user's first time
        if try await !spotHistoryRef.getDocument().exists {
            try await spotHistoryRef.setData(data)
            try await updateCheckinCount(spotId: spot.id)
        }
       
    }
    
    func checkoutLocation(spot: Location) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let spotRef = locationsRef.document(spot.id)
        try await spotRef.collection(Server.checkIns).document(uid).delete()
        try await updateLiveCount(spotId: spot.id, increment: -1)
        checkinListener?.remove()
        print("Check in listener removed!")
    }
    
    func fetchallstamps() async throws -> [Stamp]{
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.uidNotFound}
        let ref = privatesRef.document(uid).collection(Server.stamps)
        var stamps: [Stamp] = []
        let snapshot = try await ref.getDocuments()
        snapshot.documents.forEach { document in
            let data = document.data()
            let stamp = Stamp(data: data)
            stamps.append(stamp)
        }
        return stamps
    }
    
    func updateStampImage(image: UIImage, stampId: String) async throws -> String{
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.uidNotFound}
        let ref = privatesRef.document(uid).collection(Server.stamps).document(stampId)
        let url = try await ImageManager.shared.uploadStampImage(uid: uid, spotId: stampId, image: image)
        let data: [String: Any] = [
            Stamp.CodingKeys.imageUrl.rawValue: url
        ]
        try await ref.updateData(data)
        return url
    }
  
    
    
    
    
    //MARK: USER FUNCTIONS
    func createUserInDB(result: AuthDataResult) {
        let uid = result.user.uid
        let email = result.user.email ?? ""
        
        let data: [String: Any] = [
            User.CodingKeys.id.rawValue: uid,
            User.CodingKeys.email.rawValue: email,
            User.CodingKeys.timestamp.rawValue: Timestamp(),
            User.CodingKeys.streetCred.rawValue: 10
        ]

        usersRef.document(uid).setData(data)
        UserDefaults.standard.set(10, forKey: AppUserDefaults.streetcred)
        UserDefaults.standard.set(uid, forKey: AppUserDefaults.uid)
    }
    
    func checkIfUserExist(uid: String) async -> Bool {
        do {
            if try await usersRef.document(uid).getDocument().exists {
                try await loginUser(uid: uid)
                return true
            } else {
                return false
            }
        } catch (let error) {
            print(error.localizedDescription)
            return false
        }
    }

    func fetchAllUsers() async throws -> [User] {
        let ref = usersRef
        var users: [User] = []
        let snapshot = try await ref.getDocuments()
        
        snapshot.documents.forEach {
            let user = User(data: $0.data())
            users.append(user)
        }
        return users
    }
    
    func getUserFrom(id: String) async throws -> User {
        let ref = usersRef
        let snapshot = try await ref.document(id).getDocument()
        guard let data = snapshot.data() else {throw CustomError.badData}
        let user = User(data: data)
        return user
    }
    
    func loginUser(uid: String) async throws {
        let user = try await getUserFrom(id: uid)
        UserDefaults.standard.set(user.id, forKey: AppUserDefaults.uid)
        UserDefaults.standard.set(user.imageUrl, forKey: AppUserDefaults.profileUrl)
        UserDefaults.standard.set(user.username, forKey: AppUserDefaults.username)
        UserDefaults.standard.set(user.fcmToken ?? "", forKey: AppUserDefaults.fcmToken)
        UserDefaults.standard.set(user.streetCred, forKey: AppUserDefaults.streetcred)
    }
    
    func fetchUsersCheckedIn(spotId: String, completion: @escaping(Result<[Message], Error>) -> Void) {
        var messages: [Message] = []
        checkinListener = locationsRef
                        .document(spotId)
                        .collection(Server.checkIns)
                        .addSnapshotListener({ snapshot, error in
                            if let error = error {
                                print("Error fetch recent messages")
                                completion(.failure(error))
                            }
                            
                            snapshot?.documentChanges.forEach { change in
                                if change.type == .added {
                                    let data = change.document.data()
                                    let message = Message(data: data)
                                    messages.insert(message, at: 0)
                                }
                                
                                if change.type == .removed {
                                    let  id = change.document.documentID
                                    if let index = messages.firstIndex(where: {$0.id == id}) {
                                        messages.remove(at: index)
                                    }
                                }
                               
                            }
                            DispatchQueue.main.async {
                                completion(.success(messages))
                            }
                        })
    }
    
    func uploadStreetPass(imageUrl: String, username: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = usersRef.document(uid)
        UserDefaults.standard.set(username, forKey: AppUserDefaults.username)
        let data: [String: Any] = [
            User.CodingKeys.imageUrl.rawValue: imageUrl,
            User.CodingKeys.username.rawValue: username
        ]
        try await ref.setData(data)
    }
    
    func updateImageUrl(url: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let data: [String: Any] = [
            User.CodingKeys.imageUrl.rawValue: url
        ]
        
        let ref = usersRef.document(uid)
        try await ref.updateData(data)
    }
    
    func updateFcmToken(fcm: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserDefaults.standard.set(fcm, forKey: AppUserDefaults.fcmToken)
        let data: [String: Any] = [
            User.CodingKeys.fcmToken.rawValue: fcm
        ]
        let ref = usersRef.document(uid)
        ref.updateData(data)
    }
    
    func updateStreetPass(data: [String: Any]) async throws  {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = usersRef.document(uid)
        try await ref.updateData(data)
    }
    
    func updateStreetCred(counter: Int) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = usersRef.document(uid)
        let data: [String: Any] = [
            User.CodingKeys.streetCred.rawValue: FieldValue.increment(Double(counter))
        ]
        var streetcred: Int = streetcred ?? 0
        streetcred += counter
        UserDefaults.standard.set(streetcred, forKey: AppUserDefaults.streetcred)
        try await ref.updateData(data)
    }
    
    func deleteUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        try await ImageManager.shared.deleteUserProfile(uid: uid)
        try await usersRef.document(uid).delete()
        try await Auth.auth().currentUser?.delete()
        try AuthService.shared.signOut()

        UserDefaults.standard.removeObject(forKey: AppUserDefaults.uid)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.username)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.profileUrl)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.streetcred)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.spotId)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.location)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.fcmToken)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: MESSAGING FUNCTIONS
    func fetchAllMessages(completion: @escaping(Result<[Message], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var messages: [Message] = []
        
        chatListener = messageRef
            .document(uid)
            .collection(Server.recentMessages)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    print("Error fetch recent messages")
                    completion(.failure(error))
                }
                
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let message = Message(data: data)
                        messages.append(message)
                    }
                })
                DispatchQueue.main.async {
                    completion(.success(messages))
                }
        })
    }
    
    func getMessages(userId: String, completion: @escaping(Result<[Message], Error>) -> ()) {
        guard let uid  = Auth.auth().currentUser?.uid else {return}
        var messages: [Message] = []
        chatListener = messageRef
                .document(uid)
                .collection(userId)
                .addSnapshotListener({ snapshot, error in
                    if let error = error {
                        print("Error fetching messages for user")
                        completion(.failure(error))
                    }
                    
                    snapshot?.documentChanges.forEach({ change in
                        if change.type == .added {
                            let data = change.document.data()
                            let message = Message(data: data)
                            messages.append(message)
                        }
                    })
                    DispatchQueue.main.async {
                        completion(.success(messages))
                    }
                })
    }
    
    func sendMessage(user: User, content: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let fromReference = messageRef.document(uid).collection(user.id).document()
        let toFeference = messageRef.document(user.id).collection(uid).document()
        
        let data: [String: Any] = [
            Message.CodingKeys.id.rawValue: fromReference.documentID,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.toId.rawValue: user.id,
            Message.CodingKeys.content.rawValue: content,
            Message.CodingKeys.timestamp.rawValue: Timestamp()
        ]
        
        try await toFeference.setData(data)
        try await fromReference.setData(data)
        try await persistRecentMessage(id: user.id, data: data)
    }
    
    func sendLobbyMessage(content: String, spotId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let spotRef = locationsRef.document(spotId).collection(Server.checkIns).document()
        let documentId = spotRef.documentID
        let data: [String: Any] = [
            Message.CodingKeys.content.rawValue: content,
            Message.CodingKeys.id.rawValue: documentId,
            Message.CodingKeys.toId.rawValue: spotId,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.timestamp.rawValue: Timestamp(),
            Message.CodingKeys.profileUrl.rawValue: profileUrl ?? "",
            Message.CodingKeys.displayName.rawValue: username ?? ""
        ]
        try await spotRef.setData(data)
    }
    
    func persistRecentMessage(id: String, data: [String: Any]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let recentRef = privatesRef
                            .document(Server.recentMessages)
                            .collection(id).document(uid)
        
        try await recentRef.setData(data)
    }
    
    func removeChatListener() {
        chatListener?.remove()
        print("Removing chat listner")
    }
    
    func fetchRecentMessages(completion: @escaping (Result<[Message], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var messages: [Message] = []
        
        recentMessageListener = privatesRef
                .document(Server.recentMessages)
                .collection(uid)
                .addSnapshotListener({ querySnapshot, error in
                    if let error = error {
                        print("Error fetching recent messages", error.localizedDescription)
                        completion(.failure(error))
                    }
                    
                    guard let snapshot = querySnapshot else {return}
                    
                    snapshot.documentChanges.forEach { change in
                        if change.type == .added {
                            let data = change.document.data()
                            let message = Message(data: data)
                            messages.insert(message, at: 0)
                        }
                    }
                    completion(.success(messages))
                })
    }
    
    
    func deleteRecentMessage(userId: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        privatesRef
            .document(uid)
            .collection(Server.recentMessages)
            .document(userId)
            .delete()
    }
    
    
    //MARK: REQUEST FUNCTIONS
    func sendRequest(userId: String, message: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid, let imageUrl = profileUrl, let displayName = username
        else {throw CustomError.uidNotFound}
        
        let ref = privatesRef.document(userId)
                              .collection(Server.waves)
                              .document(uid)
      
        let data: [String: Any] = [
            Message.CodingKeys.id.rawValue: uid,
            Message.CodingKeys.fromId.rawValue: uid,
            Message.CodingKeys.toId.rawValue: userId,
            Message.CodingKeys.content.rawValue: message,
            Message.CodingKeys.timestamp.rawValue: Timestamp(),
            Message.CodingKeys.location.rawValue: locationName ?? "",
            Message.CodingKeys.spotId.rawValue: locationId ?? "",
            Message.CodingKeys.displayName.rawValue: displayName,
            Message.CodingKeys.profileUrl.rawValue: imageUrl
        ]
            
        try await ref.setData(data)
        try await updateStreetCred(counter: -1)
    }
    
    func fetchRequests(completion: @escaping (Result<[Message], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        var messages: [Message] = []
        
        requestListener = privatesRef.document(uid).collection(Server.waves).addSnapshotListener({ snapshot, error in
            if let error = error {
                print("Error find new connection request", error.localizedDescription)
                completion(.failure(error))
            }
            
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let message = Message(data: data)
                    messages.insert(message, at: 0)
                }
                
                if change.type == .removed {
                    let requestId = change.document.documentID
                    if let index = messages.firstIndex(where: {$0.id == requestId}) {
                        messages.remove(at: index)
                    }
                }
            })
            DispatchQueue.main.async {
                completion(.success(messages))
            }
        })
    }
    
    func removeRequestRegistration() {
        requestListener?.remove()
    }
    
    func deleteRequest(id: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.uidNotFound}
        let ref = privatesRef.document(uid).collection(Server.waves).document(id)
        try await ref.delete()
    }
    
    func acceptRequest(message: Message) throws {
        guard let uid = Auth.auth().currentUser?.uid else {throw CustomError.uidNotFound}
        
        //Create messages for both users
        let recentRef = messageRef.document(uid).collection(message.id).document()
        let messageRef = messageRef.document(message.id).collection(uid).document()
        try recentRef.setData(from: message)
        try messageRef.setData(from: message)
        
 

        //Create connecitons in personal collections
        let connectionsRef = privatesRef.document(uid).collection(Server.connections).document(message.fromId)
        let connections2Ref = privatesRef.document(message.fromId).collection(Server.connections).document(uid)
        
        let connectionData: [String: Any] = [User.CodingKeys.id.rawValue: message.toId,
                                             User.CodingKeys.timestamp.rawValue: Timestamp(),
                                             User.CodingKeys.username.rawValue: message.displayName,
                                             Message.CodingKeys.profileUrl.rawValue: message.profileUrl,
                                             Message.CodingKeys.location.rawValue: message.location ?? "",
                                             Message.CodingKeys.spotId.rawValue: message.spotId ?? ""]
        
        let connections2Data: [String: Any] = [User.CodingKeys.id.rawValue: uid,
                                               User.CodingKeys.timestamp.rawValue: Timestamp(),
                                               User.CodingKeys.username.rawValue: username ?? "",
                                               Message.CodingKeys.profileUrl.rawValue: profileUrl ?? "",
                                               Message.CodingKeys.location.rawValue: message.location ?? "",
                                               Message.CodingKeys.spotId.rawValue: message.spotId ?? ""]
        connectionsRef.setData(connectionData)
        connections2Ref.setData(connections2Data)
        
        //Update connections counter for both users and location
        let spotRef = locationsRef.document(message.spotId ?? "")
        let toRef = usersRef.document(message.toId)
        let fromRef = usersRef.document(message.fromId)
        
        let counterData: [String: Any] = [
            User.CodingKeys.connections.rawValue: FieldValue.increment(Double(1)),
            User.CodingKeys.streetCred.rawValue: FieldValue.increment(Double(1))
        ]
        
        spotRef.updateData(counterData)
        toRef.updateData(counterData)
        fromRef.updateData(counterData)
    }
    
    
    func deleteConnection(id: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userRecord = privatesRef.document(uid).collection(Server.connections).document(id)
        let connectionRecord = privatesRef.document(id).collection(Server.connections).document(uid)
        try await userRecord.delete()
        try await connectionRecord.delete()
        
        let userRef = usersRef.document(uid)
        let connectionRef = usersRef.document(id)
        let data: [String: Any] = [
            User.CodingKeys.connections.rawValue: FieldValue.increment(Double(-1)),
            User.CodingKeys.streetCred.rawValue: FieldValue.increment(Double(-1))
        ]
        try await userRef.updateData(data)
        try await connectionRef.updateData(data)
        
        let userMessage = messageRef.document(uid).collection(Server.recentMessages).document(id)
        let connectionMessage = messageRef.document(id).collection(Server.recentMessages).document(uid)
        try await userMessage.delete()
        try await connectionMessage.delete()
    }
    
    
    

    
    
}
