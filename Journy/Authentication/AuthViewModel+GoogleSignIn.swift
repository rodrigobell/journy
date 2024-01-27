import FirebaseCore
import FirebaseAuth
import GoogleSignIn

extension AuthViewModel {
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
}
