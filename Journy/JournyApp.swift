import SwiftUI

@main
struct JournyApp: App {

  @StateObject var model = PassionListViewModel()
  /// Used to detect when the app moves all scenes to the background, so we can trigger a save.
  @Environment(\.scenePhase) var scenePhase
  
    var body: some Scene {
      WindowGroup {
        NavigationView {
          PassionListView(model: model)
        }
      }
      .onChange(of: scenePhase) { phase in
        // When all our scenes have moved to the background, we force a save
        // immediately in case the user is about to terminate the app.
        if phase == .background {
          model.save()
        }
      }
    }
}
