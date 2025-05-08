import SwiftUI

struct MainView: View {
    @StateObject private var userManager   = UserManager()
    @State private var isNewUser           = false
    @State private var isSettingGoals      = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 1) Avatar + XP
                AvatarView(user: userManager.user)
                  // width = 45% of screen, height = 1.15× width + spacing (≈ circle + xp)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.45,
                        height: (UIScreen.main.bounds.width * 0.45) * 1.15 + 12
                    )

                // 2) Username + delete
                HStack {
                    Text(userManager.user.name)
                        .font(.title2)
                        .bold()
                    Button("Delete") {
                        userManager.deleteUser()
                        isNewUser = true
                    }
                    .buttonStyle(.borderedProminent)
                }

                Divider()

                // 3) “Your Exercises” header
                Text("Your Exercises")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // 4) List of saved exercises, scrollable, min 200pt tall
                List {
                    if userManager.user.exercisePool.isEmpty {
                        Text("No saved exercises yet.")
                            .italic()
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(userManager.user.exercisePool) { ex in
                            Text(ex.name)
                        }
                        .onDelete(perform: deleteFromPool)
                    }
                }
                .listStyle(.insetGrouped)
                .frame(minHeight: 200)

                Spacer()

                // 5) Manage Exercises button further down
                NavigationLink {
                    ExerciseListView(userManager: userManager)
                } label: {
                    Label("Manage Exercises", systemImage: "list.bullet")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack { // debug: reopen registration
                        Button {
                            isNewUser = true
                        } label: {
                            Image(systemName: "person.crop.circle.badge.plus")
                        }
                        NavigationLink(destination: SettingsView(userManager: userManager)) {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            }
            // 6) Registration flow
            .fullScreenCover(isPresented: $isNewUser) {
                NewUserView(userManager: userManager,
                            isNewUser:   $isNewUser)
                    .interactiveDismissDisabled()
            }
            .onChange(of: isNewUser) { newVal in
                // after sign-up, if no goals, show goals sheet
                if !newVal && userManager.user.goals.isEmpty {
                    isSettingGoals = true
                }
            }
            .sheet(isPresented: $isSettingGoals) {
                UserGoalsView(userManager:    userManager,
                              isSettingGoals: $isSettingGoals)
                    .interactiveDismissDisabled()
            }
            .onAppear {
                // initial load
                userManager.readUser()
                isNewUser = userManager.user.name.isEmpty
            }
        }
    }

    private func deleteFromPool(at offsets: IndexSet) {
        userManager.user.exercisePool.remove(atOffsets: offsets)
        userManager.saveUser()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
