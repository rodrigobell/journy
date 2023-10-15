import SwiftUI

struct PassionListView: View {
  /// The shared view model.
  @EnvironmentObject var model: PassionsModel
  
  /// All the passions that are currently selected in the list.
  @State private var selectedItems = Set<Passion>()
  
  /// Whether editing is currently active or not. We use this rather than the
  /// Environment edit mode because it creates simpler code.
  @State private var editMode = EditMode.inactive
  
  var body: some View {
    List(selection: $selectedItems) {
      ForEach($model.passions, content: PassionRowView.init)
        .onDelete(perform: model.delete)
    }
    .navigationTitle("Passions")
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        EditButton()
          .disabled(model.passions.isEmpty)
      }
      
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: model.add) {
          Label("Add Item", systemImage: "plus")
        }
      }
      
      /// When we're in editing mode we add a toolbar button to let the user
      /// delete all selected passions at once.
      ToolbarItem(placement: .bottomBar) {
        if editMode == .active {
          HStack {
            Spacer()
            
            Button(role: .destructive) {
              model.delete(selectedItems)
              selectedItems.removeAll()
              editMode = .inactive
            } label: {
              Label("Delete selected", systemImage: "trash")
            }
            .disabled(selectedItems.isEmpty)
          }
        }
      }
    }
    .animation(.default, value: model.passions)
    .listStyle(.sidebar)
    .environment(\.editMode, $editMode)
  }
}

#Preview {
    PassionListView()
}
