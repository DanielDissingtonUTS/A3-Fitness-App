import SwiftUI

struct MainView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var isNewUser      = false
    @State private var isSettingGoals = false

    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color.defaultPrimary)
                    .frame(maxWidth: 402, maxHeight: 425)
                    .position(x: 201, y: 120)
                VStack {
                    // 1) Avatar + XP
                    AvatarView(user: userManager.user)
                        .frame(
                            width: UIScreen.main.bounds.width * 0.65,
                            height: (UIScreen.main.bounds.width * 0.50) * 1.15 + 12
                        )
                    
                    // 2) Username + Delete button
                    HStack {
                        Text(userManager.user.name)
                            .font(Font.custom("ZenDots-Regular", size: 20))
                            .foregroundColor(.white)
                        Button("Delete") {
                            userManager.deleteUser()
                            isNewUser = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 20)
                    
                    Divider()
                    
                    Text("Daily Tasks")
                        .font(Font.custom("ZenDots-Regular", size: 25))
                        .bold()
                        .padding(.bottom)
                
                    ForEach(userManager.user.tasks) { task in
                        Spacer()
                        HStack {
                            
                            Image(systemName: task.complete ? "checkmark.square" : "square")
                                .foregroundColor(.accentColor) // Optional
                            Spacer()
                            VStack (alignment: .trailing) {
                                Text("\(task.description)")
                                    .font(Font.custom("ZenDots-Regular", size: 15))
                                Text("\(String(task.xp)) XP ")
                                    .font(Font.custom("ZenDots-Regular", size: 12))
                                    .foregroundColor(.black.opacity(0.5))
                            }
                        }
                    }
                    
                    Divider()
                    
                    // 3) “Your Exercises” header
                    ZStack{
                        Text("Your Exercises")
                            .font(Font.custom("ZenDots-Regular", size: 25))
                            .bold()
                            .padding(.horizontal)
                        HStack {
                            Spacer()
                            NavigationLink {
                                ExerciseListView()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    
                    
                    
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
                    .frame(minHeight: 125)
                    
                    Spacer()
                    
                    // 5) Manage Exercises
                    
                    
                    // 6) Workouts
                    NavigationLink {
                        WorkoutView()
                    } label: {
                        Label("Workouts", systemImage: "figure.walk")
                            .font(Font.custom("ZenDots-Regular", size: 20))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding()
                //.navigationTitle("Home")
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
