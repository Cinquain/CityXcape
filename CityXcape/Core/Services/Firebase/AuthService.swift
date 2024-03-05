//
//  AuthService.swift
//  CityXcape
//
//  Created by James Allan on 8/9/23.
//
import CryptoKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import SwiftUI
import AuthenticationServices

final class AuthService: NSObject, ObservableObject {
    
    static let shared = AuthService()
    private override init() {}
    var onboardingView: SignUpView!

    
    @Published var didSignIn: Bool = false
    fileprivate var currentNonce: String?

    var uid: String? {
        Auth.auth().currentUser?.uid
    }
    
    func signOut() throws {
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.uid)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.username)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.streetcred)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.profileUrl)
        UserDefaults.standard.removeObject(forKey: AppUserDefaults.createdSP)
        try Auth.auth().signOut()
    }
    
    func signInWithGoogle(credentials: AuthCredential) async throws -> Bool {
        let authResult = try await Auth.auth().signIn(with: credentials)
        let uid = authResult.user.uid
        if await DataService.shared.checkIfUserExist(uid: uid) {
            //User  already exist, set uid in User Defaults
            return true
        } else {
            //User does not exist
            print("User is brand spanking new")
            DataService.shared.createUserInDB(result: authResult)
            return false
        }
    }
    
    func signInWithAppe(credentials: AuthCredential) async throws -> Bool {
        
       let appleResult = try await Auth.auth().signIn(with: credentials)
       let uid = appleResult.user.uid
        if await DataService.shared.checkIfUserExist(uid: uid) {
            //User is already exist, set uid in User Defaults
            return true
        } else {
            //User does not exist
            print("User is brand spanking new")
            DataService.shared.createUserInDB(result: appleResult)
            return false
        }
    }
    
    
}


//Google Signin
extension AuthService {
    
    @MainActor
    func startSignInWithGoogleFlow() async throws -> Bool {
        guard let view = Utilities.shared.topViewController() else
        {
            print("Error authenticating, Cant Find View Conroller")
            throw CustomError.authFailed}

        guard let clientID = FirebaseApp.app()?.options.clientID else { throw CustomError.authFailed }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: view)
        
        guard let idToken = result.user.idToken?.tokenString else { throw CustomError.authFailed}
        let accessToken = result.user.accessToken.tokenString

            
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)
        
        do {
            return try await signInWithGoogle(credentials: credential)
        } catch {
            print("Error signing with Google", error.localizedDescription)
            throw CustomError.authFailed
        }
    }
    

    @available(iOS 13, *)
    func startSignInWithAppleFlow(view: SignUpView) {
        guard let topVC = Utilities.shared.topViewController() else {return}
          self.onboardingView = view
          let nonce = randomNonceString()
          currentNonce = nonce
          let appleIDProvider = ASAuthorizationAppleIDProvider()
          let request = appleIDProvider.createRequest()
          request.requestedScopes = [.fullName, .email]
          request.nonce = sha256(nonce)

          let authorizationController = ASAuthorizationController(authorizationRequests: [request])
          authorizationController.delegate = self
            authorizationController.presentationContextProvider = topVC
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


@available(iOS 13.0, *)
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
                   let result = try await signInWithAppe(credentials: credential)
                    await onboardingView.dismiss()
                } catch let error {
                    print("Failed to sign in with Apple", error.localizedDescription)
                }
            }
        }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
      print("Sign in with Apple errored: \(error)")
  }
    


}





