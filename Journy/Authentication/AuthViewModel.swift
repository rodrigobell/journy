import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

class AuthViewModel: ObservableObject {
  @Published var userSession: FirebaseAuth.User?
  @Published var currentUser: User?
  @Published var didSendResetPasswordLink = false
  
  static let shared = AuthViewModel()
  
  init() {
    userSession = Auth.auth().currentUser
    fetchUser()
  }
  
  func fetchUser() {
    guard let uid = userSession?.uid else { return }
    COLLECTION_USERS.document(uid).getDocument { snapshot, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      guard let snapshot = snapshot else {
        // handle the error however you like here
        return
      }
      guard let user = try? snapshot.data(as: User.self) else {
        print("Failed to fetch user")
        self.signOut()
        return
      }
      self.currentUser = user
    }
  }
  
  func signIn(withEmail email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      if let error = error {
        print("DEBUG: Email sign in failed \(error.localizedDescription)")
        return
      }
      guard let user = result?.user else { return }
      self.userSession = user
      self.fetchUser()
    }
  }
  
  func signInWithGoogle() {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    let configuration = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = configuration

    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
    
    GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signResult, error in
      if let error = error {
        print("DEBUG: Google sign in failed \(error.localizedDescription)")
        return
      }
      
      guard let user = signResult?.user,
            let idToken = user.idToken else { return }
      
      let accessToken = user.accessToken
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
      Auth.auth().signIn(with: credential) { result, error in
        if let error = error {
          print(error.localizedDescription)
        }
        guard let user = result?.user else { return }
        let data = ["email": user.email]
        COLLECTION_USERS.document(user.uid).setData(data) { _ in
          print("Successfully uploaded user data...")
          self.userSession = user
          self.fetchUser()
        }
      }
    }
  }
  
  func register(withEmail email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      guard let user = result?.user else { return }
      let data = ["email": email]
      COLLECTION_USERS.document(user.uid).setData(data) { _ in
        print("Successfully uploaded user data...")
        self.userSession = user
        self.fetchUser()
      }
    }
  }
  
  func signOut() {
    self.userSession = nil
    try? Auth.auth().signOut()
  }
  
  func resetPassword(withEmail email: String) {
    Auth.auth().sendPasswordReset(withEmail: email) { error in
      if let error = error {
        print("Failed to send link with error \(error.localizedDescription)")
        return
      }
      
      self.didSendResetPasswordLink = true
    }
  }
}
