import SwiftUI

struct PassionRowView: View {
  @Binding var passion: Passion
  @State private var isDisabled = true
  @FocusState private var isFocused: Bool
  @ObservedObject var model: PassionViewModel
  
  var body: some View {
    if (isDisabled) {
      RowView
    } else {
      RowView
    }
  }
  
  @ViewBuilder
  var RowView: some View {
    NavigationLink {
      if let passionUid = passion.id {
        PostGridView(model: PostViewModel(passionUid: passionUid, passionName: passion.name))
      }
    } label: {
      TextField("", text: $passion.name)
        .disabled(isDisabled)
        .focused($isFocused)
        .contextMenu {
          Button {
            isDisabled = false
            isFocused = true
          } label: {
            Text("Rename")
          }
          Button {
            model.delete(passion: passion)
          } label:  {
            Text("Delete")
          }
        }
        .onChange(of: passion.name, {
          model.update(passion: passion, name: passion.name)
        })
        .onChange(of: isFocused) { isFocused in
          if !isFocused {
            isDisabled = true
            model.update(passion: passion, name: passion.name)
          }
        }
    }
  }
}

#Preview {
  PassionRowView(passion: .constant(.example), model: PassionViewModel(ownerUid: User.example.id!))
}
