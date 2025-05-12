import SwiftUI
import UIKit

@main
struct A3_fitness_app: App {
    @StateObject private var userManager = UserManager()
    init(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.white)
        
        if let customFont = UIFont(name: "ZenDots-Regular", size: 35) {
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: customFont
            ]
            appearance.largeTitleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: customFont]
        } else {
            print("Custom font not found")
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userManager)   // ← so all child views can use @EnvironmentObject
        }
    }
}
