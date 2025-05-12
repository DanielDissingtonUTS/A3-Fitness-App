import SwiftUI

struct XPView: View {
    let level: Level
    @EnvironmentObject var userManager: UserManager

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            // fixed height comes from the frame we apply in AvatarView
            // draw the background “track”
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: totalWidth, height: geo.size.height)
                // draw the filled portion
                Capsule()
                    .fill((Color(userManager.user.theme.secondaryColor)))
                    .frame(
                      width: totalWidth * CGFloat(level.progress),
                      height: geo.size.height
                    )
                
            }
        }
    }
}

struct XPView_Previews: PreviewProvider {
    static var previews: some View {
        XPView(level: Level(level: 2, xp: 50))
            .frame(height: 30)
            .padding()
            .previewLayout(.sizeThatFits)
            .environmentObject(UserManager())
    }
}
