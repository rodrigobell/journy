import Firebase

class PostViewModel: ObservableObject {
  @Published var posts = [Post]()
  private let passionUid: String
  let passionName: String
  
  init(passionUid: String, passionName: String) {
    self.passionUid = passionUid
    self.passionName = passionName
    fetchPosts()
  }
  
  func fetchPosts() {
    COLLECTION_POSTS.whereField("passionUid", isEqualTo: self.passionUid).getDocuments { snapshot, _ in
      guard let documents = snapshot?.documents else { return }
      let posts = documents.compactMap({ try? $0.data(as: Post.self) })
      self.posts = posts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
  }
  
  func createPost(timestamp: Timestamp,
                  type: PostType,
                  caption: String,
                  images: Array<UIImage>,
                  completion: FirestoreCompletion) {
    var data = ["timestamp": timestamp,
                "passionUid": self.passionUid,
                "type": type.rawValue,
                "caption": caption,
                "imageUrls": Array<String>()] as [String : Any]
    if images.isEmpty {
      COLLECTION_POSTS.addDocument(data: data, completion: completion)
    } else {
      ImageService.uploadImages(images: images, type: ImageType.post) { imageUrls in
        data["imageUrls"] = imageUrls
        COLLECTION_POSTS.addDocument(data: data, completion: completion)
      }
    }
  }
  
  func delete(post: Post) {
    // TODO: Turn this into an async call
    guard let postUid = post.id else { return }
    for imageUrl in post.imageUrls {
      ImageService.deleteImage(imageUrl: imageUrl, type: ImageType.post)
    }
    COLLECTION_POSTS.document(postUid).delete(completion: { _ in
      self.fetchPosts()
    })
  }
}
