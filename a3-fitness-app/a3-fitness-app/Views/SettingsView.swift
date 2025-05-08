import SwiftUI

struct SettingsView: View {
    @StateObject var userManager: UserManager
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
            
            VStack {
                Text("SettingsView")
                
                Spacer()
                
                VStack {
                    Text("Themes")
                        .font(.title)
                    
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, spacing: 0) {
                            ForEach(themes, id: \.name) { theme in
                                themeTile(for: theme, size: size * 0.3)
                            }
                        }
                    }
                }
                .background(.white)
                
                Spacer()
            }
        }
        .onAppear {
            updateThemes()
        }
    }
        
    private func updateThemes() {
        for index in themes.indices {
            if userManager.user.level.level >= themes[index].requiredLevel {
                themes[index].unlocked = true
            }
        }
    }
    
    @ViewBuilder
    func themeTile(for theme: Theme, size: CGFloat) -> some View {
        let tile = ThemeView(theme: theme)
            .frame(width: size, height: size)
            .padding(size * 0.05)
        
        if theme.unlocked {
            if theme == userManager.user.theme {
                tile
                    .overlay(
                        RoundedRectangle(cornerRadius: size * 0.1)
                            .stroke(Color(userManager.user.theme.primaryColor), lineWidth: size * 0.03)
                            .padding(size * 0.05)
                    )

            } else {
                Button(action: {
                    userManager.updateUser(theme: theme)
                }) {
                    tile
                }
                    .buttonStyle(.plain)
            }
        } else {
            ZStack {
                tile
                    .opacity(0.6)
                ZStack {
                    Image(systemName: "lock.fill")
                        .font(.system(size: size * 0.4))
                        .foregroundColor(.yellow)
                    
                    Text(String(theme.requiredLevel))
                        .font(.system(size: size * 0.2))
                        .fontWeight(.bold)
                        .offset(y: size * 0.07)
                }
                    .position(x: size * 0.55, y: size * 0.45)
            }
        }
    }
}

#Preview {
    SettingsView(userManager: UserManager())
}
