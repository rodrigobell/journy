import Foundation

struct Post: Codable, Identifiable, Hashable {
  
  var id = UUID()
  var title = "New Post"
  var passionId = -1
  
}
