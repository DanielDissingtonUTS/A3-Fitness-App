import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var userManager: UserManager
    let workoutIndex: Int

    // UI state for each set
    @State private var setCompletions: [Bool] = []
    @State private var actualReps:      [Int]  = []
    @State private var weightInputs:    [String] = []

    @Environment(\.dismiss) private var dismiss

    // Convenience: the workout array & single workout
    private var workouts: [Workout]? {
        userManager.user.workouts
    }
    private var workout: Workout? {
        guard let ws = workouts, ws.indices.contains(workoutIndex) else { return nil }
        return ws[workoutIndex]
    }

    var body: some View {
        Group {
            if let workout = workout {
                Form {
                    ForEach(0..<workout.sets.count, id: \.self) { idx in
                        let set = workout.sets[idx]
                        let title = set.exercises.first?.name ?? "Exercise"

                        // --- HERE’S THE NEW HEADER LOGIC ---
                        // Find all the indices of this same exercise
                        let sameExerciseIndices = workout.sets.enumerated()
                            .compactMap { $1.exercises.first?.name == title ? $0 : nil }
                        // Position in that group
                        let position = (sameExerciseIndices.firstIndex(of: idx) ?? 0) + 1
                        let total = sameExerciseIndices.count

                        Section(header: Text("\(title) — Set \(position) of \(total)")) {
                            // Target
                            HStack {
                                Text("Target:")
                                Spacer()
                                Text("\(set.targetReps) reps")
                            }
                            // Actual
                            HStack {
                                Text("Actual:")
                                Spacer()
                                TextField(
                                    "0",
                                    text: Binding(
                                        get: {
                                            actualReps.indices.contains(idx)
                                                ? String(actualReps[idx])
                                                : ""
                                        },
                                        set: { newValue in
                                            if actualReps.indices.contains(idx) {
                                                actualReps[idx] = Int(newValue) ?? set.targetReps
                                            }
                                        }
                                    )
                                )
                                .keyboardType(.numberPad)
                                Text(" reps")
                            }
                            // Weight
                            HStack {
                                Text("Weight:")
                                Spacer()
                                TextField(
                                    "kg",
                                    text: Binding(
                                        get: {
                                            weightInputs.indices.contains(idx)
                                                ? weightInputs[idx]
                                                : ""
                                        },
                                        set: { newValue in
                                            if weightInputs.indices.contains(idx) {
                                                weightInputs[idx] = newValue
                                            }
                                        }
                                    )
                                )
                                .keyboardType(.decimalPad)
                                Text(" kg")
                            }
                            // Done toggle
                            Toggle(
                                "Done",
                                isOn: Binding(
                                    get: {
                                        setCompletions.indices.contains(idx)
                                            ? setCompletions[idx]
                                            : false
                                    },
                                    set: { newValue in
                                        if setCompletions.indices.contains(idx) {
                                            setCompletions[idx] = newValue
                                        }
                                    }
                                )
                            )
                        }
                    }

                    Button("Finish Workout") {
                        saveResults()
                        dismiss()
                    }
                    .disabled(!setCompletions.allSatisfy { $0 })
                }
                .navigationTitle(workout.name)
                .onAppear(perform: initializeState)
            } else {
                Text("Unable to load workout.")
                    .foregroundColor(.secondary)
                    .onAppear { dismiss() }
            }
        }
    }

    private func initializeState() {
        guard let workout = workout else { return }
        let count = workout.sets.count
        setCompletions = Array(repeating: false, count: count)
        actualReps    = workout.sets.map(\.targetReps)
        weightInputs = workout.sets.map { set in
            set.weight.map { String($0) } ?? ""
        }
    }

    private func saveResults() {
        guard var ws = userManager.user.workouts,
              ws.indices.contains(workoutIndex)
        else { return }

        var w = ws[workoutIndex]
        for idx in w.sets.indices {
            if actualReps.indices.contains(idx) {
                w.sets[idx].totalReps = actualReps[idx]
            }
            if weightInputs.indices.contains(idx),
               let val = Double(weightInputs[idx]) {
                w.sets[idx].weight = val
            }
        }

        ws[workoutIndex] = w
        userManager.user.workouts = ws
        userManager.saveUser()
    }
}
