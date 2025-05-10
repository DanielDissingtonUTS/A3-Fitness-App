import SwiftUI

@main
struct A3_fitness_app: App {
    @StateObject private var userManager = UserManager()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userManager)   // ← so all child views can use @EnvironmentObject
        }
    }
}
