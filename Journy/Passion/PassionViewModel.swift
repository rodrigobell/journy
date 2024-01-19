import Combine
import Foundation
import Firebase
import FirebaseFirestoreSwift

class PassionViewModel: ObservableObject {
  @Published var passions = [Passion]()
  private let ownerUid: String

  init(ownerUid uid: String) {
    self.ownerUid = uid
  }

  func fetchPassions() {
    COLLECTION_PASSIONS.whereField("ownerUid", isEqualTo: self.ownerUid).getDocuments { snapshot, _ in
      guard let documents = snapshot?.documents else { return }
      let passions = documents.compactMap({ try? $0.data(as: Passion.self) })
      self.passions = passions.sorted(by: { $0.timestamp.dateValue() < $1.timestamp.dateValue() })
    }
  }

  func createPassion() {
    var passion = Passion(ownerUid: ownerUid)
    passion.name = "New Passion " + String(passions.count + 1)
    let data = ["timestamp": passion.timestamp,
                "ownerUid": passion.ownerUid,
                "name": passion.name] as [String : Any]
    COLLECTION_PASSIONS.addDocument(data: data)
    fetchPassions()
  }

  func deletePosts(forPassionUid passionUid: String) {
    COLLECTION_POSTS.whereField("passionUid", isEqualTo: passionUid).getDocuments { snapshot, _ in
      guard let documents = snapshot?.documents else { return }
      let posts = documents.compactMap({ try? $0.data(as: Post.self) })
      for post in posts {
        guard let uid = post.id else { return }
        for imageUrl in post.imageUrls {
          ImageService.deleteImage(imageUrl: imageUrl, type: ImageType.post)
        }
        COLLECTION_POSTS.document(uid).delete(completion: nil)
      }
    }
  }

  func delete(passion: Passion) {
    // TODO: Turn this into an async call
    guard let passionUid = passion.id else { return }
    COLLECTION_PASSIONS.document(passionUid).delete(completion: nil)
    deletePosts(forPassionUid: passionUid)
    fetchPassions()
  }
}
