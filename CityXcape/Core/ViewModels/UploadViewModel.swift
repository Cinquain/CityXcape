//
//  UploadViewModel.swift
//  CityXcape
//
//  Created by James Allan on 3/2/24.
//

import Foundation
import PhotosUI
import SwiftUI


@MainActor
class UploadViewModel: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet {Task{ await loadImage(from:selectedImage)}}
    }
    
    @Published var postImage: UIImage?
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var profileUrl: String = ""
    
    func loadImage(from item: PhotosPickerItem?) async {
        guard let uid = AuthService.shared.uid else {return}
        guard let item = item else {return}
        guard let data = try? await item.loadTransferable(type: Data.self) else {return}
        guard let uiImage = UIImage(data: data) else {return}
        Task {
            do {
                let url = try await ImageManager.shared.uploadProfileImage(uid: uid, image: uiImage)
                try await DataService.shared.updateImageUrl(url: url)
                self.profileUrl = url
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
    
}
