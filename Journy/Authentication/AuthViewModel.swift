import SwiftUI
import FirebaseAuth

class AuthViewModel: ObservableObject {
  @Published var userSession: FirebaseAuth.User?
  @Published var currentUser: User?
  @Published var didSendResetPasswordLink = false
  
  static let shared = AuthViewModel()
  
  init() {
    userSession = Auth.auth().currentUser
    fetchUser()
  }
  
  func login(withEmail email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { result, error in
      if let error = error {
        print("DEBUG: Login failed \(error.localizedDescription)")
        return
      }
      
      guard let user = result?.user else { return }
      self.userSession = user
      self.fetchUser()
    }
  }
  
  func register(withEmail email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { result, error in
      if let error = error {
        print(error.localizedDescription)
        return
      }
      
      guard let user = result?.user else { return }
      print("Successfully registered user...")
      
      let data = ["email": email]
      
      COLLECTION_USERS.document(user.uid).setData(data) { _ in
        print("Successfully uploaded user data...")
        self.userSession = user
        self.fetchUser()
      }
    }
  }
  
  func signout() {
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
        self.signout()
        return
      }
      self.currentUser = user
    }
  }
}
