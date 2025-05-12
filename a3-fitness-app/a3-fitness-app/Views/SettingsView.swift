import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userManager: UserManager
    @StateObject private var settingsViewModel: SettingsViewModel = SettingsViewModel()
    @State private var themes: [Theme] = Themes.all

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width // Width of the view
            let height = geo.size.height // Height of the view
            let size = min(width, height)
            
            let rows = [GridItem(.fixed(size * 0.325))]
            
            Rectangle()
                .fill(Color(userManager.user.theme.secondaryColor))
                .ignoresSafeArea()
            
            
            VStack (spacing: height * 0.025) {
                ZStack {
                    Rectangle()
                        .fill(Color(userManager.user.theme.primaryColor))
                        .ignoresSafeArea()
                    
                    Text("Settings")
                        .foregroundColor(.white)
                        .font(Font.custom("ZenDots-Regular", size: 30))
                        .fontWeight(.bold)
                }
                    .frame(height: height * 0.1)
                
                VStack {
                    Text("Themes")
                        .font(Font.custom("ZenDots-Regular", size: 25))
                        .padding(.top)

                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 0) {
                            ForEach(themes, id: \.name) { theme in
                                themeTile(for: theme, size: size * 0.3)
                            }
                        }
                    }
                }
                    .background(.white)
                
                    .frame(width: 400, height: 300)
                    .background(.white)
                    
                    
                Spacer()
            }
        }
        .onAppear {
            let userLevel = userManager.user.level.level
            
            settingsViewModel.unlockThemes(userLevel: userLevel, themes: &themes)
        }
    }
    
    func themeTile(for theme: Theme, size: CGFloat) -> some View {
        let tile = ThemeView(theme: theme)
            .frame(width: size, height: size)
            .padding(size * 0.05)
        
        if !theme.unlocked {
            return AnyView (
                ZStack {
                    tile
                        .opacity(0.6)
                    
                    ZStack {
                        Image(systemName: "lock.fill")
                            .font(.system(size: size * 0.5))
                            .foregroundColor(.yellow)
                        
                        Text(String(theme.requiredLevel))
                            .font(.system(size: size * 0.3))
                            .fontWeight(.bold)
                            .offset(y: size * 0.1)
                    }
                        .position(x: size * 0.55, y: size * 0.45)
                }
            )
        }
        
        if theme == userManager.user.theme {
            return AnyView(
                tile
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.1)
                        .stroke(Color(userManager.user.theme.primaryColor), lineWidth: size * 0.03)
                        .padding(size * 0.05)
                    )
            )
        }
        
        return AnyView (
            Button(action: {
                userManager.updateUser(theme: theme)
            }) {
                tile
            }
                .buttonStyle(.plain)
        )
    }
}

#Preview {
    SettingsView()
        .environmentObject(UserManager.shared)
}
