import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var model: AuthViewModel
  @State private var isPresentingAccountDeletionConfirmation: Bool = false

  
  var body: some View {
    List {
      Button(action: { model.signOut() }) {
        Label("Sign Out", systemImage: "door.left.hand.open")
      }
      Button {
        isPresentingAccountDeletionConfirmation = true
      } label: {
        Label("Delete Account (Cannot Be Undone)", systemImage: "trash")
      }
      .confirmationDialog("", isPresented: $isPresentingAccountDeletionConfirmation) {
        Button("Delete Account", role: .destructive) {
          model.deleteAccount()
        }
      }
    }
    .navigationTitle("Settings")
  }
}

#Preview {
  NavigationStack {
    SettingsView()
  }
}
