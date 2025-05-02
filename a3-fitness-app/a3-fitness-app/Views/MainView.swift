import SwiftUI

struct MainView: View {
    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat = geometry.size.width
            let height: CGFloat = geometry.size.height
            
            ZStack {
                Rectangle()
                    .fill(Color.background)
                    .ignoresSafeArea()
                VStack {
                    let avatarSize: CGFloat = width * 0.45
                    
                    AvatarView(level: 1, progress: 0.8)
                        .frame(width: avatarSize, height: avatarSize)

                    Spacer()                    
                }
            }
        }
    }
}

#Preview {
    MainView()
}
