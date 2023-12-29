import SwiftUI

struct PostCellView: View {
  var post: Post
  
  var body: some View {
    Text(post.title)
  }
}

#Preview {
  PostCellView(post: .example)
}
