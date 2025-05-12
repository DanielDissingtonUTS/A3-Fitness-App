import SwiftUI

struct PRView: View {
    @EnvironmentObject var userManager: UserManager

    /// Builds a list of (exercise name → max weight) pairs
    private var records: [(String, Double)] {
        guard let workouts = userManager.user.workouts else { return [] }

        var best: [String: (weight: Double, reps: Int, exercise: Exercise)] = [:]

        for workout in workouts {
            for set in workout.sets {
                guard let exercise = set.exercises.first,
                      let weight = set.weight,
                      let reps = set.totalReps else { continue }

                let key = exercise.id
                let current = best[key]

                // Replace if this set is heavier or equally heavy with more reps
                if current == nil || weight > current!.weight || (weight == current!.weight && reps > current!.reps) {
                    best[key] = (weight: weight, reps: reps, exercise: exercise)
                }
            }
        }

        // Build PRRecord array and update userManager
        let prRecords = best.values.map { record in
            PRRecord(exercise: record.exercise, bestReps: record.reps, bestWeight: record.weight)
        }
        userManager.updateUser(prRecords: prRecords)

        return best.map { ($0.key, $0.value.weight) }
                   .sorted { $0.0 < $1.0 }
    }

    var body: some View {
        List {
            if records.isEmpty {
                Text("No records yet. Finish a workout to start setting PRs!")
                    .foregroundColor(.secondary)
            } else {
                ForEach(records, id: \.0) { name, wt in
                    
                    HStack {
                        Text(name)
                        Spacer()
                        Text("\(wt, specifier: "%.1f") kg")
                    }
                }
            }
        }
        .navigationTitle("Personal Records")
        .onAppear {
            
        }
    }
        
}
