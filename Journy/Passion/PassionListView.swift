import SwiftUI

struct PassionListView: View {
  @ObservedObject var model: PassionViewModel
    
  var body: some View {
    List {
      ForEach($model.passions) { passion in
        PassionRowView(passion: passion, model: model)
      }
    }
    .navigationTitle("My Passions")
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: { model.createPassion() }) {
          Label("", systemImage: "plus")
        }
      }
    }
    .animation(.default, value: model.passions)
    .listStyle(.sidebar)
    .onAppear {
      model.fetchPassions()
    }
  }
}

#Preview {
  NavigationStack {
    PassionListView(model: PassionViewModel(ownerUid: User.example.id!))
  }
}
