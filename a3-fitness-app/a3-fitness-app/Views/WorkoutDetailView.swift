import SwiftUI

struct WorkoutDetailView: View {
  @EnvironmentObject var userManager: UserManager
  let workoutIndex: Int

  // MARK: – UI state, one slot per set
  @State private var actualReps:   [String] = []
  @State private var weightInputs: [String] = []
  @State private var isDone:       [Bool]   = []

  // Conveniences
  private var workout: Workout {
    userManager.user.workouts![workoutIndex]
  }
  private var sets: [ExerciseSet] {
    workout.sets
  }

  var body: some View {
    Form {
      // For each set
      ForEach(sets.indices, id: \.self) { idx in
        let set = sets[idx]

        Section(header: Text(set.exercises.first?.name ?? "")) {
          // TARGET
          HStack {
            Text("Target:")
            Spacer()
            Text("\(set.targetReps) reps")
          }

          // ACTUAL
          HStack {
            Text("Actual:")
            Spacer()
            TextField(
              "reps",
              text: Binding(
                get: { actualReps[safe: idx] ?? "\(set.targetReps)" },
                set: { new in
                  pad(&actualReps, toAtLeast: idx + 1, with: "")
                  actualReps[idx] = new
                }
              )
            )
            .keyboardType(.numberPad)
            .frame(width: 60)
          }

          // WEIGHT
          HStack {
            Text("Weight:")
            Spacer()
            TextField(
              "kg",
              text: Binding(
                get: { weightInputs[safe: idx] ?? "" },
                set: { new in
                  pad(&weightInputs, toAtLeast: idx + 1, with: "")
                  weightInputs[idx] = new
                }
              )
            )
            .keyboardType(.decimalPad)
            .frame(width: 80)
          }

          // COMPLETED
          Toggle(
            "Done",
            isOn: Binding(
              get: { isDone[safe: idx] ?? false },
              set: { new in
                pad(&isDone, toAtLeast: idx + 1, with: false)
                isDone[idx] = new
              }
            )
          )
        }
      }

      // FINISH BUTTON
      Button("Finish Workout") {
        saveResults()
      }
      .disabled(!isDone.allSatisfy { $0 })
    }
    .navigationTitle(workout.name)
    .onAppear(perform: initializeState)
  }

  // MARK: – Initialization & helpers

  private func initializeState() {
    let count = sets.count

    // Start with the model’s targets and weights
    actualReps   = sets.map { "\($0.targetReps)" }
    weightInputs = sets.map { $0.weight.map { "\($0)" } ?? "" }
    isDone       = Array(repeating: false, count: count)
  }

  private func saveResults() {
    var copy = userManager.user
    var all   = copy.workouts!

    var w = all[workoutIndex]
    for i in w.sets.indices {
      // parse actual reps
      if let reps = Int(actualReps[safe: i] ?? "") {
        w.sets[i].totalReps = reps
      }
      // parse weight
      if let wgt = Double(weightInputs[safe: i] ?? "") {
        w.sets[i].weight = wgt
      }
    }

    all[workoutIndex] = w
    copy.workouts     = all
    userManager.user  = copy
    userManager.saveUser()
  }

  /// Ensures `arr.count >= minCount`, padding with `defaultValue` if needed.
  private func pad<T>(_ arr: inout [T], toAtLeast minCount: Int, with defaultValue: T) {
    if arr.count < minCount {
      arr.append(contentsOf: Array(repeating: defaultValue, count: minCount - arr.count))
    }
  }
}

// MARK: – Safe‐index extension

private extension Array {
  subscript(safe i: Int) -> Element? {
    indices.contains(i) ? self[i] : nil
  }
}
