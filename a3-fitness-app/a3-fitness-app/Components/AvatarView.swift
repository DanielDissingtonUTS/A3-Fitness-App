import SwiftUI

struct AvatarView: View {
    var level: Int
    var progress: Float
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                
                Circle()
                    .fill(Color.yellow)
                    .frame(width: width, height: height)
                
                Image("AvatarPlaceholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: width, height: height)

                XPView(level: level, progress: progress)
                    .frame(width: width, height: height * 2)
                    .position(x: width / 2, y: height * 1)
            }
        }
    }
}

#Preview {
    AvatarView(level: 1, progress: 0.5)
        .frame(width: 300, height: 300)
}
