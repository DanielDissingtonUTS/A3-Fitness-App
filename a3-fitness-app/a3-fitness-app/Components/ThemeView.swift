import SwiftUI

struct ThemeView: View {    
    var theme: Theme
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width // Width of the view
            let height = geo.size.height // Height of the view
            let size = min(width, height)
            
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.1)
                    .fill(Color.clear)
                    .frame(width: size, height: size)
    
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color(theme.primaryColor))
                            .frame(width: size * 0.7, height: size * 0.7)
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .rotation(Angle(degrees: 270))
                            .fill(Color(theme.secondaryColor))
                            .frame(width: size * 0.7, height: size * 0.7)
                        Circle()
                            .stroke(Color(theme.tertiaryColor), lineWidth: size * 0.025)
                            .background(Circle().fill(Color.clear))
                            .frame(width: size * 0.33, height: size * 0.33)
                    }
                    
                    Text(theme.name)
                        .font(.system(size: size * 0.11))
                }
            }
        }
    }
}

#Preview {
    ThemeView(theme: Themes.all[0])
        .frame(width: 300, height: 300)
}
