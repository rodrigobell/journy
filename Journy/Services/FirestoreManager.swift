import FirebaseCore

class FirestoreManager {
  static let shared = FirestoreManager()
  
  // TODO, move creation logic to this manager
  
  func deleteUser(uid: String, completion: FirestoreCompletion) {
    self.deletePassions(forUserUid: uid, completion: { _ in
      COLLECTION_USERS.document(uid).delete(completion: completion)
    })
  }
  
  func deletePassion(uid: String, completion: FirestoreCompletion) {
    self.deletePosts(forPassionUid: uid, completion: { _ in
      COLLECTION_PASSIONS.document(uid).delete(completion: completion)
    })
  }
  
  func deletePost(post: Post, completion: FirestoreCompletion) {
    guard let postUid = post.id else { return }
    COLLECTION_POSTS.document(postUid).delete(completion: completion)
    for imageUrl in post.imageUrls {
      ImageService.deleteImage(imageUrl: imageUrl, type: ImageType.post)
    }
  }
  
  func deletePassions(forUserUid userUid: String, completion: FirestoreCompletion) {
    COLLECTION_PASSIONS.whereField("userUid", isEqualTo: userUid).getDocuments { snapshot, _ in
      guard let documents = snapshot?.documents else { return }
      let passions = documents.compactMap({ try? $0.data(as: Passion.self) })
      for passion in passions {
        guard let passionUid = passion.id else { return }
        self.deletePosts(forPassionUid: passionUid, completion: completion)
      }
    }
  }
  
  func deletePosts(forPassionUid passionUid: String, completion: FirestoreCompletion) {
    COLLECTION_POSTS.whereField("passionUid", isEqualTo: passionUid).getDocuments { snapshot, _ in
      guard let documents = snapshot?.documents else { return }
      let posts = documents.compactMap({ try? $0.data(as: Post.self) })
      for post in posts {
        guard let postUid = post.id else { return }
        for imageUrl in post.imageUrls {
          ImageService.deleteImage(imageUrl: imageUrl, type: ImageType.post)
        }
        self.deletePost(post: post, completion: completion)
      }
    }
  }
}
