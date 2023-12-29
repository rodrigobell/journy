import SwiftUI

struct PassionRowView: View {
  @Binding var passion: Passion
  @State private var isDisabled = true
  @FocusState private var isFocused: Bool
  
  var body: some View {
    if (isDisabled) {
      NavigationLink {
        PostGridView(model: PostGridViewModel(passion: passion))
      } label: {
        TextField("", text: $passion.title)
          .disabled(isDisabled)
          .focused($isFocused)
          .contextMenu {
            Button {
              isDisabled = false
              isFocused = true
            } label: {
              Text("Change name")
            }
          }
          .onChange(of: isFocused) { isFocused in
            if !isFocused {
              isDisabled = true
            }
          }
      }
    }
  }
}

#Preview {
  PassionRowView(passion: .constant(.example))
}
