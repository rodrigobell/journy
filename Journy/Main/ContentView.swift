import SwiftUI

struct ContentView: View {
  @State var selectedIndex = 2
  @EnvironmentObject var authViewModel: AuthViewModel
  
  var body: some View {
    if authViewModel.userSession == nil {
      LoginView()
    } else {
      if let user = authViewModel.currentUser {
        NavigationView {
          PassionListView(model: PassionViewModel(ownerUid: user.id!))
        }
      }
    }
  }
}
