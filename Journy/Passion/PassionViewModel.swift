import Combine
import Foundation
import Firebase
import FirebaseFirestoreSwift

class PassionViewModel: ObservableObject {
  @Published var passions = [Passion]()
  @Published var postCount = 0
  private let ownerUid: String

  init(ownerUid uid: String) {
    self.ownerUid = uid
    fetchPassions()
  }

  func fetchPassions() {
    COLLECTION_PASSIONS.whereField("ownerUid", isEqualTo: self.ownerUid).getDocuments { snapshot, _ in
      guard let documents = snapshot?.documents else { return }
      let passions = documents.compactMap({ try? $0.data(as: Passion.self) })
      self.passions = passions.sorted(by: { $0.name < $1.name })
      self.fetchPostCount() // todo: don't call this here
    }
  }
  
  func fetchPostCount() {
    var curPostCount = 0
    var passionsChecked = 0
    for passion in passions {
      guard let passionUid = passion.id else { return }
      COLLECTION_POSTS.whereField("passionUid", isEqualTo: passionUid).getDocuments { snapshot, _ in
        guard let documents = snapshot?.documents else { return }
        curPostCount += documents.count
        passionsChecked += 1
        if passionsChecked == self.passions.count {
          self.postCount = curPostCount
        }
      }
    }
  }

  func createPassion() {
    let name = "New Passion " + String(passions.count + 1)
    let data = ["timestamp": Timestamp(date: Date.now),
                "ownerUid": ownerUid,
                "name": name] as [String : Any]
    COLLECTION_PASSIONS.addDocument(data: data, completion: { _ in
      self.fetchPassions()
    })
  }
  
  func update(passion: Passion, name: String) {
    guard let passionUid = passion.id else { return }
    COLLECTION_PASSIONS.document(passionUid).updateData(["name": name])
  }

  func delete(passion: Passion) {
    guard let passionUid = passion.id else { return }
    FirestoreManager.shared.deletePassion(uid: passionUid, completion: { _ in
      self.fetchPassions()
    })
  }
}
