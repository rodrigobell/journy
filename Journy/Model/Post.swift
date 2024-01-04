import Foundation

enum PostType: String, Codable, CaseIterable {
  case photo, text
}

struct Post: Codable, Identifiable, Hashable {
  var id = UUID()
  var type = PostType.text
  var date = Date.now
  var caption = ""
  var imageData: Data? = nil
}

extension Post: Equatable {
  static func ==(lhs: Post, rhs: Post) -> Bool {
    return lhs.id == rhs.id && lhs.id == rhs.id
  }
}
