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
                    HStack {
                        AvatarView(level: 1)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    MainView()
}
