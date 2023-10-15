import Combine
import Foundation

class PassionsModel: ObservableObject {
  /// The array of passions our app is working with.
  @Published var passions: [Passion]
  
  private let savePath = FileManager.documentsDirectory.appendingPathComponent("UserPassions")
  
  /// An active Combine chain that watches for changes to the `passions` array, and calls save()
  /// 5 seconds after a change has happened.
  private var saveSubscription: AnyCancellable?
  
  /// An empty initializer that loads our data from disk.
  init() {
    do {
      // Attempt to load saved data for this app.1
      let data = try Data(contentsOf: savePath)
      passions = try JSONDecoder().decode([Passion].self, from: data)
    } catch {
      // Loading failed, so start with an empty array.
      passions = []
    }
    
    // Wait 5 seconds after `passions` has changed before calling `save()`, to
    // avoid repeatedly calling it for every tiny change.
    saveSubscription = $passions
      .debounce(for: 5, scheduler: RunLoop.main)
      .sink { [weak self] _ in
        self?.save()
      }
  }
  
  /// Converts our passions to JSON, then saves it to disk.
  func save() {
    do {
      let data = try JSONEncoder().encode(passions)
      try data.write(to: savePath, options: [.atomic, .completeFileProtection])
    } catch {
      print("Unable to save data")
    }
  }
  
  /// Adds one new item to the array.
  func add() {
    let newItem = Passion()
    passions.append(newItem)
  }
  
  /// Deletes several passions from the array; used with onDelete() in `ContentView` to
  /// enable swipe to delete.
  /// - Parameter offsets: The `IndexSet` of passions we should be deleting.
  func delete(_ offsets: IndexSet) {
    passions.remove(atOffsets: offsets)
  }
  
  /// Deletes several passions from the array; used with the trash button in `ContentView` to
  /// enable deleting multiple selection passions in the list.
  /// - Parameter selected: A set of passions to delete.
  func delete(_ selected: Set<Passion>) {
    passions.removeAll(where: selected.contains)
  }
}
