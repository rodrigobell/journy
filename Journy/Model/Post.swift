import Firebase
import FirebaseFirestoreSwift

enum PostType: String, Codable, CaseIterable {
  case photo, text
}

struct Post: Codable, Identifiable, Equatable {
  @DocumentID var id: String?
  var timestamp: Timestamp = Timestamp(date: Date())
  let passionUid: String
  var type = PostType.text
  var caption = ""
  var imageUrls = Array<String>()
}
