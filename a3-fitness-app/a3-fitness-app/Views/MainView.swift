import SwiftUI

struct MainView: View {
    
    @State private var user: User = User(name: "", level: Level(level: 1, xp: 0))
    @State private var isNewUser: Bool = false
    
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
                    
                    AvatarView(user: user)
                        .frame(width: avatarSize, height: avatarSize)
                    
                    Text("Welcome back,\n\(user.name)")
                        .padding()
                        .padding()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
            }
        }
        
        .onAppear {
            if user.name.isEmpty {
                isNewUser = true
            }
        }
        
        .sheet(isPresented: $isNewUser) {
            NewUserView(user: $user, isNewUser: $isNewUser)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    MainView()
}
