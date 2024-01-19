import SwiftUI
import WaterfallGrid

struct PostGridView: View {
  @ObservedObject var model: PostViewModel
  @State private var showingCreatePostPopover = false
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      WaterfallGrid(model.posts) { post in
        PostCellView(post: post)
          .fixedSize(horizontal: false, vertical: true)
          .contextMenu {
            Button {
              model.delete(post: post)
            } label: {
              Text("Delete")
            }
          }
      }
      .gridStyle(
        columnsInPortrait: 2,
        columnsInLandscape: 3,
        spacing: 8
      )
      .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
    }
    .navigationTitle(model.passionName)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("", systemImage: "plus") {
          showingCreatePostPopover = true
        }
        .sheet(isPresented: $showingCreatePostPopover) {
          CreatePostView(model: model)
        }
      }
    }
    .onChange(of: showingCreatePostPopover, {
      if !showingCreatePostPopover {
        model.fetchPosts()
      }
    })
    .onAppear {
      model.fetchPosts()
    }
  }
}

#Preview {
  NavigationStack {
    let model = PostViewModel(passionUid: Passion.example.id!, passionName: Passion.example.name)
    model.createPost(timestamp: Post.example.timestamp, type: Post.example.type, caption: Post.example.caption, images: [UIImage](), completion: nil)
    return PostGridView(model: model)
  }
}
