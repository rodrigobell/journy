import FirebaseCore
import FirebaseAuth

class AuthViewModel: NSObject, ObservableObject {
  @Published var userSession: FirebaseAuth.User?
  @Published var currentUser: User?
  @Published var didSendResetPasswordLink = false
  var appleNonce: String?
  
  static let shared = AuthViewModel()
  
  override init() {
    super.init()
    userSession = Auth.auth().currentUser
    self.fetchUser()
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
    self.currentUser = nil
    self.appleNonce = nil
    try? Auth.auth().signOut()
  }
  
  func deleteAccount() {
    guard let uid = userSession?.uid else { return }
    FirestoreManager.shared.deleteUser(uid: uid, completion: { _ in
      self.userSession?.delete { error in
        if let error = error {
          print("Failed to delete user account with error \(error.localizedDescription)")
        } else {
          print("Deleted user account")
          self.signOut()
        }
      }
    })
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
