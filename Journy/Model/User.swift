import FirebaseCore
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
  @DocumentID var id: String?
  let email: String
  var isCurrentUser: Bool { return AuthViewModel.shared.userSession?.uid == id }
}
