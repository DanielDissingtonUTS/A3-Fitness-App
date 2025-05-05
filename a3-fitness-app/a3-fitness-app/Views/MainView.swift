import SwiftUI

struct MainView: View {
    @StateObject private var userManager = UserManager()
    @State private var isNewUser: Bool = false
    @State private var exercises: [Exercise] = []
    
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
                        
                    AvatarView(user: userManager.user)
                        .frame(width: avatarSize, height: avatarSize)
                    
                    HStack {
                        Text(userManager.user.name)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        Button("Delete") {
                            userManager.deleteUser()
                            isNewUser = userManager.user.name.isEmpty
                        }
                            .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, height * 0.075)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.blue)
                    
                    ForEach(exercises, id: \.self) { exercise in
                        Text(exercise.name)
                    }
                    
                    Spacer()
                }
            }
        }
        
        .onAppear {
            Task {
                do {
                    exercises = try await fetchExercises(limit: 5)
                } catch {
                    print("Error: \(error)")
                }
            }
            
            userManager.readUser()
            
            isNewUser = userManager.user.name.isEmpty
        }
        
        .sheet(isPresented: $isNewUser) {
            NewUserView(isNewUser: $isNewUser)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    MainView()
}
