import Combine
import Foundation

class PostGridViewModel: ObservableObject {
  let passion: Passion
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
    do {
      let data = try JSONEncoder().encode(posts)
      try data.write(to: savePath, options: [.atomic, .completeFileProtection])
    } catch {
      print("Unable to save data")
    }
  }
  
  func add() {
    let newItem = Post()
    posts.append(newItem)
  }
  
  func delete(_ offsets: IndexSet) {
    posts.remove(atOffsets: offsets)
  }
}
