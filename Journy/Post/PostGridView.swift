import SwiftUI
import WaterfallGrid

struct PostGridView: View {
  let kMinNumberGridColumns = 1
  let kMaxNumberGridColumns = 2
  @ObservedObject var model: PostViewModel
  @State private var showingCreatePostPopover = false
  @State private var numberGridColumns = 2
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      WaterfallGrid(model.posts) { post in
        PostCellView(post: post, numberGridColumns: $numberGridColumns)
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
        columnsInPortrait: numberGridColumns,
        columnsInLandscape: numberGridColumns,
        spacing: 20
      )
      .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
    }
    .navigationTitle(model.passionName)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        HStack {
          Button {
            if numberGridColumns < kMaxNumberGridColumns {
              numberGridColumns += 1
            } else {
              numberGridColumns = kMinNumberGridColumns
            }
          } label: {
            Text(String(repeating: "| ", count: numberGridColumns))
              .font(.title3)
          }
          Button("", systemImage: "plus") {
            showingCreatePostPopover = true
          }
          .sheet(isPresented: $showingCreatePostPopover) {
            CreatePostView(model: model)
          }
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
