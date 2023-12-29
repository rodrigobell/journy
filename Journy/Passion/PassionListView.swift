import SwiftUI

struct PassionListView: View {
  @ObservedObject var model: PassionListViewModel
    
  var body: some View {
    List {
      ForEach($model.passions, content: PassionRowView.init)
        .onDelete(perform: model.delete)
    }
    .navigationTitle("My Passions")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: model.add) {
          Label("Add Item", systemImage: "plus")
        }
      }
    }
    .animation(.default, value: model.passions)
    .listStyle(.sidebar)
  }
}

#Preview {
  NavigationStack {
    PassionListView(model: PassionListViewModel())
  }
}
