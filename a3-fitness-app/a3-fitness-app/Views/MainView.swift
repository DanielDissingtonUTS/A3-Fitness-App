import SwiftUI

struct MainView: View {
    @StateObject private var userManager   = UserManager()
    @State private var isNewUser           = false
    @State private var isSettingGoals      = false
    @State private var exercises: [Exercise] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.background
                    .ignoresSafeArea()

                VStack {
                    AvatarView(user: userManager.user)
                        .frame(width: geo.size.width * 0.45,
                               height: geo.size.width * 0.45)

                    HStack {
                        Text(userManager.user.name)
                            .font(.title)
                            .multilineTextAlignment(.center)
                        Button("Delete") {
                            userManager.deleteUser()
                            isNewUser = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 20)

                    Divider()

                    ForEach(exercises, id: \.self) { ex in
                        Text(ex.name)
                    }

                    Spacer()
                }
            }
        }
        .onAppear {
            // 1) Load user from disk
            userManager.readUser()
            // 2) Show registration if no name
            isNewUser = userManager.user.name.isEmpty

            // 3) Fire off API fetch
            Task {
                do {
                    exercises = try await fetchExercises(limit: 5)
                } catch {
                    print("Fetch error:", error)
                }
            }
        }
        // 4) Full-screen cover for registration
        .fullScreenCover(isPresented: $isNewUser) {
            NewUserView(
                userManager: userManager,
                isNewUser:   $isNewUser
            )
            .interactiveDismissDisabled()
        }
        // 5) Once the cover dismisses, if no goals set, show sheet
        .onChange(of: isNewUser) {
            // zero-param closure: `isNewUser` is already captured
            if !isNewUser && userManager.user.goals.isEmpty {
                isSettingGoals = true
            }
        }
        // 6) Sheet for picking goals
        .sheet(isPresented: $isSettingGoals) {
            UserGoalsView(
                userManager:    userManager,
                isSettingGoals: $isSettingGoals
            )
            .interactiveDismissDisabled()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
