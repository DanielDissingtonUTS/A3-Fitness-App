import SwiftUI

struct NewWorkoutView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var isShowing: Bool

    // 1) Workout name
    @State private var workoutName = ""

    // 2) Selected pool exercises
    @State private var selectedExercises: [Exercise] = []

    // 3) Sets & reps per exercise
    @State private var setsByExercise: [Exercise: Int] = [:]
    @State private var repsByExercise: [Exercise: Int] = [:]

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Workout Name
                Section("Workout Name") {
                    TextField("Enter a name", text: $workoutName)
                }

                // MARK: Pick Exercises
                Section("Pick Exercises") {
                    ForEach(userManager.user.exercisePool) { ex in
                        MultipleSelectionRow(
                            title: ex.name,
                            isSelected: selectedExercises.contains(ex)
                        ) {
                            toggleExercise(ex)
                        }
                    }
                }

                // MARK: Sets & Reps
                if !selectedExercises.isEmpty {
                    Section("Sets & Reps") {
                        ForEach(selectedExercises, id: \.id) { ex in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(ex.name).bold()

                                HStack {
                                    Text("Sets:")
                                    Spacer()
                                    Stepper(
                                        value: Binding(
                                            get: { setsByExercise[ex] ?? 1 },
                                            set: { setsByExercise[ex] = $0 }
                                        ),
                                        in: 1...10
                                    ) {
                                        Text("\(setsByExercise[ex] ?? 1)")
                                    }
                                }

                                HStack {
                                    Text("Reps:")
                                    Spacer()
                                    Stepper(
                                        value: Binding(
                                            get: { repsByExercise[ex] ?? 1 },
                                            set: { repsByExercise[ex] = $0 }
                                        ),
                                        in: 1...50
                                    ) {
                                        Text("\(repsByExercise[ex] ?? 1)")
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("New Workout")
            .toolbar {
                // Cancel
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isShowing = false }
                }
                // Save
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveWorkout()
                        isShowing = false
                    }
                    .disabled(workoutName.isEmpty || selectedExercises.isEmpty)
                }
            }
        }
    }

    private func toggleExercise(_ ex: Exercise) {
        if let idx = selectedExercises.firstIndex(of: ex) {
            selectedExercises.remove(at: idx)
            setsByExercise[ex] = nil
            repsByExercise[ex] = nil
        } else {
            selectedExercises.append(ex)
            setsByExercise[ex] = 3   // default
            repsByExercise[ex] = 8   // default
        }
    }

    private func saveWorkout() {
        // Build one ExerciseSet per “set” the user chose
          var sets: [ExerciseSet] = []
          for ex in selectedExercises {
            let reps  = repsByExercise[ex] ?? 1
            let count = setsByExercise[ex]   ?? 1
            for _ in 1...count {
              sets.append(
                ExerciseSet(
                  exercises:   [ex],
                  targetReps:  reps,
                  totalReps:   nil,
                  weight:      nil
                )
              )
            }
          }

        // Create the Workout
        let workout = Workout(
            name: workoutName,
            exercises: selectedExercises,
            sets: sets
        )

        // Persist it
        var copy = userManager.user
        if copy.workouts == nil { copy.workouts = [] }
        copy.workouts!.append(workout)
        userManager.user = copy
        userManager.saveUser()
    }
}
