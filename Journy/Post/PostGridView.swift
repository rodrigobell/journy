import SwiftUI
import WaterfallGrid

struct PostGridView: View {
  @ObservedObject var model: PostGridViewModel
  @State private var showingCreatePostPopover = false
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      WaterfallGrid(model.posts) { post in
        PostCellView(post: post)
      }
      .gridStyle(
        columnsInPortrait: 2,
        columnsInLandscape: 3,
        spacing: 8,
        animation: .none
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
    PostGridView(model: PostGridViewModel(passion: .example))
  }
}
