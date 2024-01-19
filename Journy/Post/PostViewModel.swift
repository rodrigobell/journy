import Firebase

class PostViewModel: ObservableObject {
  @Published var posts = [Post]()
  private let passionUid: String
  let passionName: String
  
  init(passionUid: String, passionName: String) {
    self.passionUid = passionUid
    self.passionName = passionName
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
    ImageService.uploadImages(images: images, type: ImageType.post) { imageUrls in
      let post = Post(timestamp: timestamp,
                      passionUid: self.passionUid,
                      type: type,
                      caption: caption,
                      imageUrls: imageUrls)
      let data = ["timestamp": post.timestamp,
                  "passionUid": post.passionUid,
                  "type": post.type.rawValue,
                  "caption": post.caption,
                  "imageUrls": post.imageUrls] as [String : Any]
      COLLECTION_POSTS.addDocument(data: data, completion: completion)
      self.fetchPosts()
    }
  }
  
  func delete(post: Post) {
    // TODO: Turn this into an async call
    guard let postUid = post.id else { return }
    COLLECTION_PASSIONS.document(postUid).delete(completion: nil)
    fetchPosts()
  }
}
