import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var userManager: UserManager
    let workoutIndex: Int
    
    // MARK: — UI state
    @State private var setCompletions: [Bool] = []
    @State private var actualReps:      [Int]    = []
    @State private var weightInputs:    [String] = []
    @State private var hitPR:           [Bool]   = []
    
    // NEW: show the “Good job!” overlay
    @State private var showPRPrompt = false
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: — Safely pull out the Workout
    private var workout: Workout? {
        guard let ws = userManager.user.workouts,
              ws.indices.contains(workoutIndex)
        else { return nil }
        return ws[workoutIndex]
    }
    
    var body: some View {
        Group {
            if let workout = workout {
                Form {
                    // For each set in this workout
                    ForEach(workout.sets.indices, id: \.self) { idx in
                        let set = workout.sets[idx]
                        let name = set.exercises.first?.name ?? "Exercise"
                        
                        // — Build “Set X of Y” for this exercise
                        let sameExerciseIndices = workout.sets.enumerated()
                            .compactMap { (i, s) in
                                s.exercises.first?.name == name ? i : nil
                            }
                        let position = (sameExerciseIndices.firstIndex(of: idx) ?? 0) + 1
                        let total    = sameExerciseIndices.count
                        
                        Section(
                            header: Text("\(name) — Set \(position) of \(total)"),
                            footer: hitPR.indices.contains(idx) && hitPR[idx]
                            ? Text("🎉 New PR!").foregroundColor(.green)
                            : nil
                        ) {
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
                                        get: { actualReps.indices.contains(idx)
                                            ? String(actualReps[idx])
                                            : "" },
                                        set: { val in
                                            if actualReps.indices.contains(idx) {
                                                actualReps[idx] = Int(val) ?? set.targetReps
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
                                        get: { weightInputs.indices.contains(idx)
                                            ? weightInputs[idx]
                                            : "" },
                                        set: { val in
                                            if weightInputs.indices.contains(idx) {
                                                weightInputs[idx] = val
                                            }
                                        }
                                    )
                                )
                                .keyboardType(.decimalPad)
                                Text("kg")
                            }
                            
                            // Done toggle
                            Toggle(
                                "Done",
                                isOn: Binding(
                                    get: { setCompletions.indices.contains(idx)
                                        ? setCompletions[idx]
                                        : false },
                                    set: { newVal in
                                        if setCompletions.indices.contains(idx) {
                                            setCompletions[idx] = newVal
                                        }
                                    }
                                )
                            )
                        }
                    }
                    
                    // Finish button now shows the “Good job!” sheet
                    Button("Finish Workout") {
                        saveResultsAndPRs()
                        showPRPrompt = true
                    }
                    .disabled(!setCompletions.allSatisfy { $0 })
                }
                .navigationTitle(workout.name)
                .onAppear(perform: initializeState)
                // NEW: present the PR prompt overlay
                .sheet(isPresented: $showPRPrompt) {
                    PRPromptView()
                        .environmentObject(userManager)
                }
            }
            else {
                Text("Unable to load workout.")
                    .foregroundColor(.secondary)
                    .onAppear { dismiss() }
            }
        }
    }
    
    // MARK: — Initialize all your arrays
    private func initializeState() {
        guard let workout = workout else { return }
        let count = workout.sets.count
        
        setCompletions = Array(repeating: false, count: count)
        actualReps     = workout.sets.map(\.targetReps)
        weightInputs   = workout.sets.map { set in
            if let w = set.weight { String(format: "%g", w) }
            else { "" }
        }
        hitPR = Array(repeating: false, count: count)
    }
    
    
    // MARK: — Save results *and* PRs
    // MARK: — Save results *and* PRs
    private func saveResultsAndPRs() {
      guard var ws = userManager.user.workouts,
            ws.indices.contains(workoutIndex)
      else { return }

      var w = ws[workoutIndex]
      var updatedPRs = userManager.user.prRecords  // Get current PR list

      for idx in w.sets.indices {
        let reps   = actualReps.indices.contains(idx)
                     ? actualReps[idx]
                     : w.sets[idx].targetReps
        let weight = Double(weightInputs.indices.contains(idx)
                            ? weightInputs[idx]
                            : "") ?? 0

        // 1) write back into the workout
        w.sets[idx].totalReps = reps
        w.sets[idx].weight    = weight

        // 2) Check & save PR
        guard let exercise = w.sets[idx].exercises.first else { continue }
        let exId = exercise.id

        if let index = updatedPRs.firstIndex(where: { $0.exercise.id == exId }) {
          let old = updatedPRs[index]
          if reps > old.bestReps || (reps == old.bestReps && weight > old.bestWeight) {
            updatedPRs[index] = PRRecord(
              exercise: exercise,
              bestReps: reps,
              bestWeight: weight
            )
            hitPR[idx] = true
          }
        } else {
          updatedPRs.append(PRRecord(
            exercise: exercise,
            bestReps: reps,
            bestWeight: weight
          ))
          hitPR[idx] = true
        }
      }

      // 3) persist both workout + PRs
      ws[workoutIndex] = w
      userManager.updateUser(workouts: ws, prRecords: updatedPRs)
    }

}
