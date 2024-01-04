import Combine
import Foundation

class PassionListViewModel: ObservableObject {
  @Published var passions: [Passion]
  private let savePath = FileManager.documentsDirectory.appendingPathComponent("UserPassions")
  private var saveSubscription: AnyCancellable?
  
  init() {
    do {
      let docsPath = FileManager.documentsDirectory
      let data = try Data(contentsOf: savePath)
      passions = try JSONDecoder().decode([Passion].self, from: data)
    } catch {
      passions = []
    }
    
    // Wait 5 seconds before calling `save()`, to repeatedly calling it for every tiny change.
    saveSubscription = $passions
      .debounce(for: 5, scheduler: RunLoop.main)
      .sink { [weak self] _ in
        self?.save()
      }
  }
  
  func save() {
    do {
      print("Write " + savePath.relativeString)
      let data = try JSONEncoder().encode(passions)
      try data.write(to: savePath, options: [.atomic, .completeFileProtection])
    } catch {
      print("Unable to save data")
    }
  }
  
  func add() {
    let newItem = Passion()
    passions.append(newItem)
    save()
  }

  func delete(_ offsets: IndexSet) {
    passions.remove(atOffsets: offsets)
    save()
  }
}
