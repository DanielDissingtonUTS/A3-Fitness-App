import SwiftUI

struct AvatarView: View {
    let user: User

    var body: some View {
        VStack(spacing: 16) {
            // 1) The round avatar
            Image("AvatarPlaceholder")
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                // pick a diameter we like:
                .frame(width: 200, height: 200)

            // 2) The XP bar + labels
            XPView(level: user.level)
                // make it thicker:
                .frame(height: 30)
                .padding(.horizontal, 20)

            // 3) Level & XP text underneath
            HStack {
                Text("\(user.level.xp) / \(user.level.level * 100) XP")
                    .font(Font.custom("ZenDots-Regular", size: 15))
                Spacer()
                Text("Lv. \(user.level.level)")
                    .font(Font.custom("ZenDots-Regular", size: 15))
            }
            .padding(.horizontal, 30)
        }
    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(user: .init(
            name: "Test",
            level: Level(level: 3, xp: 65),
            workouts: nil,
            goals: [],
            goalsDate: nil,
            exercisePool: []
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
