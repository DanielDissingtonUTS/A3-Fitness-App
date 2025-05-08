import SwiftUI

struct MainView: View {
    @StateObject private var userManager   = UserManager()
    @State private var isNewUser           = false
    @State private var isSettingGoals      = false
    @State private var exercises: [Exercise] = []

    var body: some View {
        NavigationStack {
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
                            Text(ex.name.capitalized)
                        }

                        Spacer()
                    }
                }
            }
            .onAppear {
                // 1) Load (or create) the user
                userManager.readUser()
                isNewUser = userManager.user.name.isEmpty

                // 2) Decide if we need to show today’s goals
                if !userManager.user.name.isEmpty {
                    if let date = userManager.user.goalsDate,
                       Calendar.current.isDateInToday(date) {
                        isSettingGoals = false
                    } else {
                        isSettingGoals = true
                    }
                }

                // 3) Fetch some sample exercises
                Task {
                    do {
                        exercises = try await fetchExercises(limit: 5)
                    } catch {
                        print("Fetch error:", error)
                    }
                }
            }
            // full-screen welcome / registration
            .fullScreenCover(isPresented: $isNewUser) {
                NewUserView(
                    userManager: userManager,
                    isNewUser:   $isNewUser
                )
                .interactiveDismissDisabled()
            }
            // after registration, re-evaluate goals prompt
            .onChange(of: isNewUser) { _, newVal in
                if !newVal {
                    if let date = userManager.user.goalsDate,
                       Calendar.current.isDateInToday(date) {
                        isSettingGoals = false
                    } else {
                        isSettingGoals = true
                    }
                }
            }
            // daily goals sheet
            .sheet(isPresented: $isSettingGoals) {
                UserGoalsView(
                    userManager:    userManager,
                    isSettingGoals: $isSettingGoals
                )
                .interactiveDismissDisabled()
            }
            
            Button("🗑️ Clear Goals Date") {
              var copy = userManager.user
              copy.goalsDate = nil
              userManager.user = copy
              userManager.saveUser()
              isSettingGoals = true
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
