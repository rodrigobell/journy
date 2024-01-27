import Firebase
import FirebaseFirestoreSwift

struct Passion: Identifiable, Decodable, Equatable {
  @DocumentID var id: String?
  var timestamp: Timestamp = Timestamp(date: Date())
  let ownerUid: String
  var name: String = "New Passion"
}

extension Passion {
  static let example = Passion(id: "123", ownerUid: User.example.id!, name: "Running")
}
