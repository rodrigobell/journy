import Combine
import Foundation

class PostGridViewModel: ObservableObject {
  let passion: Passion
  var deleted = false
  @Published var posts: [Post]
  private var savePath: URL
  private var saveSubscription: AnyCancellable?
  
  init(passion: Passion) {
    self.passion = passion
    savePath = FileManager.documentsDirectory.appendingPathComponent("UserPosts" + passion.id.uuidString)
    do {
      let data = try Data(contentsOf: savePath)
      posts = try JSONDecoder().decode([Post].self, from: data)
    } catch {
      posts = []
    }
    
    // Wait 5 seconds before calling `save()`, to repeatedly calling it for every tiny change.
    saveSubscription = $posts
      .debounce(for: 5, scheduler: RunLoop.main)
      .sink { [weak self] _ in
        self?.save()
      }
  }
  
  func save() {
    if self.deleted {
      return
    }
    do {
      print("Write " + savePath.relativeString)
      let data = try JSONEncoder().encode(posts)
      try data.write(to: savePath, options: [.atomic, .completeFileProtection])
    } catch {
      print("Unable to save data")
    }
  }
  
  func add(post: Post) {
    posts.append(post)
    posts.sort(by: { $0.date.compare($1.date) == .orderedDescending})
    save()
  }
  
  func delete(post: Post) {
    posts.remove(object: post)
    save()
  }
}
