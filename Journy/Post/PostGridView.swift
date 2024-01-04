import SwiftUI
import WaterfallGrid

struct PostGridView: View {
  @ObservedObject var model: PostGridViewModel
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
    .navigationTitle(model.passion.title)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("", systemImage: "plus") {
          showingCreatePostPopover = true
        }
        .sheet(isPresented: $showingCreatePostPopover) {
          CreatePostPopoverView(model: model)
        }
      }
    }
    .onDisappear {
      model.save()
    }
  }
}

#Preview {
  NavigationStack {
    var model = PostGridViewModel(passion: .example)
    var post = Post()
    post.caption = "This is a caption for a post"
    model.add(post: post)
    return PostGridView(model: model)
  }
}
