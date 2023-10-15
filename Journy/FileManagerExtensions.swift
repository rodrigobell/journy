import Foundation

/// A small extension on `FileManager` that returns the documents directory for this app.
extension FileManager {
  /// The documents directory for this app.
  static var documentsDirectory: URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
