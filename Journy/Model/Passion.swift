import Foundation

struct Passion: Codable, Identifiable, Hashable {
  var id = UUID()
  var title = "New Passion"
}

extension Passion: Equatable {
  static func ==(lhs: Passion, rhs: Passion) -> Bool {
    return lhs.id == rhs.id && lhs.id == rhs.id
  }
}
