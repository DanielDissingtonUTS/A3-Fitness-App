import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showingNewWorkout = false

    var body: some View {
        NavigationStack {
            List {
                if let workouts = userManager.user.workouts, !workouts.isEmpty {
                    ForEach(workouts.indices, id: \.self) { idx in
                        NavigationLink {
                          WorkoutDetailView(workoutIndex: idx)
                            .environmentObject(userManager)
                        } label: {
                          Text(workouts[idx].name)
                        }
                    }
                    .onDelete(perform: deleteWorkouts)
                } else {
                    Text("No workouts yet.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewWorkout = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewWorkout) {
                NewWorkoutView(isShowing: $showingNewWorkout)
                    .environmentObject(userManager)
            }
        }
    }

    private func deleteWorkouts(at offsets: IndexSet) {
        userManager.user.workouts?.remove(atOffsets: offsets)
        userManager.saveUser()
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
            .environmentObject(UserManager())
    }
}
