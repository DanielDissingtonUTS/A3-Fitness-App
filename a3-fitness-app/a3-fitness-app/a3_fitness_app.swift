import SwiftUI

@main
struct a3_fitness_app: App {
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(UserManager.shared)
        }
    }
}
