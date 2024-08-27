//
//  AuthService.swift
//  CityXcape
//
//  Created by James Allan on 8/26/24.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import FirebaseCore


final class AuthService: NSObject, ObservableObject {
    
    static let shared = AuthService()
    private override init() {}
    
    
    @Published var isSignedIn: Bool = false
    fileprivate var currentNonce: String?
    
    var uid: String? {
        Auth.auth().currentUser?.uid
    }
    
    //MARK: Generic Auth Functions
    func signOut() throws {
        try Auth.auth().signOut()
        UserDefaults.standard.removeObject(forKey: CXUserDefaults.uid)
    }
        
}


//Google Signin
extension AuthService {
    
    
    func signInWithGoogle(credentials: AuthCredential) async throws -> Bool {
        let authResult = try await Auth.auth().signIn(with: credentials)
        let uid = authResult.user.uid
        if try await DataService.shared.checkIfUserExist(uid: uid) {
            return true
        } else {
            DataService.shared.createUser(result: authResult)
            return false
        }
    }
    
    @MainActor
    func startSigninWithGoogle() async throws -> Bool {
        guard let view = Utilities.shared.topViewController() else {
            print("Failed to get top Viewcontroller")
            throw CustomError.authFailure
        }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Failed to get client ID")
            throw CustomError.authFailure
        }
        
        //Present Google sign in modal
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: view)
        
        guard let idToken = result.user.idToken?.tokenString else {
            print("Failed to get google ID token")
            throw CustomError.authFailure
        }
        let accessToken = result.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        do {
            return try await signInWithGoogle(credentials: credential)
        } catch {
            print("Error signing in with Google", error.localizedDescription)
            throw CustomError.authFailure
        }
    }
    
}



