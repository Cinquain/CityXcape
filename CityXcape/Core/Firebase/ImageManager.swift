//
//  ImageManager.swift
//  CityXcape
//
//  Created by James Allan on 9/4/24.
//

import UIKit
import FirebaseStorage
import Firebase

class ImageManager: NSObject {
    
    static let shared = ImageManager()
    private override init() {}
    
    private var storageRef = Storage.storage()
    
    
    //MARK: CREATE FUNCTIONS
    func uploadProfileImage(uid: String, image: UIImage) async throws -> String {
        let path = getProfileImagePath(uid: uid)
        
        do {
            let url = try await uploadImage(path: path, image: image)
            try await DataService.shared.uploadImageUrl(uid: uid, url: url)
            UserDefaults.standard.set(url, forKey: CXUserDefaults.profileUrl)
            AnalyticService.shared.uploadedProfilePic()
            return url
        } catch {
            throw error
        }
    }
    
    func uploadLocationImage(spotId: String, image: UIImage) async throws -> String {
        let path = getLocationImagePath(spotId: spotId)
        
        do {
            return try await uploadImage(path: path, image: image)
        } catch {
            throw error
        }
    }
    
    func uploadStampImage(uid: String, spotId: String, image: UIImage) async throws -> String {
        let path = getStampImagePath(uid: uid, spotId: spotId)
        
        do {
            let imageUrl = try await uploadImage(path: path, image: image)
            try await DataService.shared.updateStampImage(stampId: spotId, imageUrl: imageUrl)
            return imageUrl
        } catch {
            throw error
        }
    }
    
    //MARK: STORAGE PATHS
    fileprivate func getProfileImagePath(uid: String) -> StorageReference {
        let userPath = "Users/\(uid)/profileImage"
        return storageRef.reference(withPath: userPath)
    }
    
    fileprivate func getLocationImagePath(spotId: String) -> StorageReference {
        let locationPath = "Locations/\(spotId)/mainImage"
        return storageRef.reference(withPath: locationPath)
    }
    
    fileprivate func getStampImagePath(uid: String, spotId: String) -> StorageReference {
        let stampPath = "Stamps/\(uid)/\(spotId)/stampImage"
        return storageRef.reference(withPath: stampPath)
    }
    
    
    
    //MARK: DELETE FUNCTIONS
    func deleteUserProfile(uid: String) async throws {
        let userPath = "Users/\(uid)"
        let path = storageRef.reference(withPath: userPath)
        try await path.delete()
    }
    
    func deleteSpotImage(spotId: String) async throws {
        let locationPath = "Locations/\(spotId)"
        let path = storageRef.reference(withPath: locationPath)
        try await path.delete()
    }

    
    //MARK: UPLOAD IMAGE COMPRESSION
    fileprivate func uploadImage(path: StorageReference, image: UIImage) async throws -> String {
        var compression: CGFloat = 1.0
        let maxFileSize: Int = 550 * 550
        let maxCompression: CGFloat = 0.5
        
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data from image")
            throw CustomError.badCompression
        }
        
        while (originalData.count > maxFileSize) && (compression > maxCompression) {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
        }
        
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            print("Error getting data for final image")
            throw CustomError.badCompression
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let result = try await path.putDataAsync(finalData, metadata: metadata)
        
        do {
            let downloadUrl = try await path.downloadURL().absoluteString
            return downloadUrl
        } catch {
            print("Error fetching download url", error.localizedDescription)
            throw error
        }
    }
}
