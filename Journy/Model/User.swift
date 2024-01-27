import FirebaseCore
import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
  @DocumentID var id: String?
  let email: String
  var isCurrentUser: Bool { return AuthViewModel.shared.userSession?.uid == id }
}

extension User {
  static let example = User(id: "123", email: "test@gmail.com")
}
