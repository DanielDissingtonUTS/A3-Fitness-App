import SwiftUI

struct AvatarView: View {
    var level: Int = 1
    
    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat = geometry.size.width
            
            ZStack {
                Image("AvatarPlaceholder")
                    .resizable()
                    .background(Color.yellow)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: width * 0.2, height: width * 0.2)
            }
        }
    }
}

#Preview {
    AvatarView()
}
