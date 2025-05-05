import SwiftUI

struct AvatarView: View {
    var user: User
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let size = min(width, height)
                
                Circle()
                    .fill(Color.yellow)
                    .frame(width: size, height: size)
                
                Image("AvatarPlaceholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: size, height: size)

                XPView(level: user.level)
                    .frame(width: width, height: height * 2)
                    .position(x: width / 2, y: height)
            }
        }
    }
}

#Preview {
    AvatarView(user: User(name: "", level: Level(level: 1, xp: 50)))
        .frame(width: 300, height: 300)
}
