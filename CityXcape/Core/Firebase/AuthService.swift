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
import CryptoKit


final class AuthService: NSObject, ObservableObject {
    
    static let shared = AuthService()
    private override init() {}
    var signupView: SignUp!
    
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


//Apple Signin

extension AuthService {
    
    @MainActor
    func signInWithApple(credentials: AuthCredential) async throws -> Bool {
        let authResult = try await Auth.auth().signIn(with: credentials)
        let uid = authResult.user.uid
        if try await DataService.shared.checkIfUserExist(uid: uid) {
            UserDefaults.standard.set(uid, forKey: CXUserDefaults.uid)
            return true
        } else {
            DataService.shared.createUser(auth: authResult)
            return false
        }
    }
    
    @MainActor @available(iOS 13, *)
       func startSignInWithAppleFlow(view: SignUp) {
           guard let topVC = Utilities.shared.topViewController() else {return}
             self.signupView = view
             let nonce = randomNonceString()
             currentNonce = nonce
             let appleIDProvider = ASAuthorizationAppleIDProvider()
             let request = appleIDProvider.createRequest()
             request.requestedScopes = [.fullName, .email]
             request.nonce = sha256(nonce)

             let authorizationController = ASAuthorizationController(authorizationRequests: [request])
             authorizationController.delegate = self
           authorizationController.presentationContextProvider = topVC as? any ASAuthorizationControllerPresentationContextProviding
             authorizationController.performRequests()
       }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}


//MARK: Google Signin
extension AuthService {
    
    @MainActor
    func signInWithGoogle(credentials: AuthCredential) async throws -> Bool {
        let authResult = try await Auth.auth().signIn(with: credentials)
        let uid = authResult.user.uid
        if try await DataService.shared.checkIfUserExist(uid: uid) {
            //Log in user using DataService
            return true
        } else {
            DataService.shared.createUser(auth: authResult)
            return false
        } 
    }
    
    @MainActor @discardableResult
    func startSigninWithGoogle(signUpview: SignUp) async throws -> Bool {
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
            let result = try await signInWithGoogle(credentials: credential)
            signUpview.isAuth = true 
            signUpview.dismiss()
            return result
        } catch {
            print("Error signing in with Google", error.localizedDescription)
            throw CustomError.authFailure
        }
    }
    
}

extension AuthService: ASAuthorizationControllerDelegate {
    
    internal func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
          if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
              fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetch identity token")
              return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
            }
            // Initialize a Firebase credential, including the user's full name.
            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                              rawNonce: nonce,
                                                              fullName: appleIDCredential.fullName)
            // Sign in with Firebase.
              Task {
                  do {
                     let result = try await signInWithApple(credentials: credential)
                      await signupView.dismiss()
                  } catch let error {
                      print("Failed to sign in with Apple", error.localizedDescription)
                  }
              }
          }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       // Handle error.
        print("Sign in with Apple errored: \(error.localizedDescription)")
     }
}




