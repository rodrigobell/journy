import SwiftUI

/// Displays a single item from the list in `ContentView`.
struct PassionRowView: View {
  /// A live binding to the item we're trying to show. This comes direct from our view model.
  @Binding var passion: Passion
  
  var body: some View {
    Label(passion.title, systemImage: "exclamationmark.square")
      .labelStyle(.titleOnly)

//    NavigationLink {
//      DetailView(item: $item)
//    } label: {
//      Label(item.title, systemImage: item.icon)
//        .animation(nil, value: item)
//    }
//    .tag(item)
//    .accessibilityValue(item.accessibilityValue)
  }
}

struct PassionRow_Previews: PreviewProvider {
  static var previews: some View {
    PassionRowView(passion: .constant(.example))
  }
}
