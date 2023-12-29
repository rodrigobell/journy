import SwiftUI

struct PostCellView: View {
  var post: Post
  
  var body: some View {
    switch post.type {
    case .photo:
      Text("IMAGE") // TODO
    case .text:
      Text(post.caption)
    default:
      Text("Post type error")
    }
  }
}

#Preview {
  PostCellView(post: .example)
}
