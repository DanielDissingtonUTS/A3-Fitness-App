import SwiftUI

struct MainView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var isNewUser      = false
    @State private var isSettingGoals = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1) Avatar + XP
                    AvatarView(user: userManager.user)
                        .frame(
                            width: UIScreen.main.bounds.width * 0.45,
                            height: (UIScreen.main.bounds.width * 0.45) * 1.15 + 12
                        )

                    // 2) Username + Delete button
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
                    
                    Text("Daily Tasks")
                        .font(.title2)
                        .bold()
                    
                    ForEach(userManager.user.tasks) { task in
                        HStack {
                            Image(systemName: task.complete ? "checkmark.square" : "square")
                                .foregroundColor(.accentColor) // Optional
                            Spacer()
                            VStack (alignment: .trailing) {
                                Text("\(task.description)")
                                    .font(.body)
                                Text("\(String(task.xp)) XP ")
                            }
                        }
                    }

                    Divider()

                    // 3) “Your Exercises” header
                    Text("Your Exercises")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    // 4) Scrollable list of saved exercises (min 200pt tall)
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

                    // 5) Manage Exercises
                    NavigationLink {
                        ExerciseListView()
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

                    // 6) Workouts
                    NavigationLink {
                        WorkoutView()
                    } label: {
                        Label("Workouts", systemImage: "figure.walk")
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
                        HStack {
                            // Force‐open registration for testing
                            Button {
                                isNewUser = true
                            } label: {
                                Image(systemName: "person.crop.circle.badge.plus")
                            }
                            // Settings
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape")
                            }
                        }
                    }
                }
                // 7) Registration flow
                .fullScreenCover(isPresented: $isNewUser) {
                    NewUserView(isNewUser: $isNewUser)
                        .interactiveDismissDisabled()
                }
                // 8) After sign-up, prompt goals if none set
                .onChange(of: isNewUser) { newVal in
                    if !newVal && userManager.user.goals.isEmpty {
                        isSettingGoals = true
                    }
                }
                .sheet(isPresented: $isSettingGoals) {
                    UserGoalsView(isSettingGoals: $isSettingGoals)
                        .interactiveDismissDisabled()
                }
                // 9) Initial load
                .onAppear {
                    userManager.readUser()
                    isNewUser = userManager.user.name.isEmpty
                }
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
            .environmentObject(UserManager())
    }
} 
