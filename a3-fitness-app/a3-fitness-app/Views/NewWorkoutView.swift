import SwiftUI

struct NewWorkoutView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var isShowing: Bool

    @State private var workoutName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Workout Name") {
                    TextField("Enter a name", text: $workoutName)
                }
                // you can add more fields here: exercises, sets, etc.
            }
            .navigationTitle("New Workout")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isShowing = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Create a new Workout model and append
                        let newWorkout = Workout(name: workoutName,
                                                 exercises: [],
                                                 sets: [])
                        if userManager.user.workouts == nil {
                            userManager.user.workouts = []
                        }
                        userManager.user.workouts?.append(newWorkout)
                        userManager.saveUser()
                        isShowing = false
                    }
                    .disabled(workoutName.isEmpty)
                }
            }
        }
    }
}

struct NewWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutView(isShowing: .constant(true))
            .environmentObject(UserManager())    
    }
}
