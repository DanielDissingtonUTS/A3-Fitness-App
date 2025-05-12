import SwiftUI

struct PRView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var records: [(String, Double)] = []

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
            records = calculateRecords()
        }
    }
    
    func calculateRecords() -> [(String, Double)]{
        var task1complete: Bool = false
        
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
                    task1complete = true
                }
            }
        }
        
        print("Broke for loop")

        // Build PRRecord array and update userManager
        let prRecords = best.values.map { record in
            PRRecord(exercise: record.exercise, bestReps: record.reps, bestWeight: record.weight)
        }
        
        if let lastWorkout = userManager.user.workouts?.last {
            let uniqueExercises = Set(lastWorkout.sets.compactMap { $0.exercises.first?.id })
            let task2complete = uniqueExercises.count >= 2
            userManager.user.tasks[1].complete = task2complete
        }
        
        userManager.user.tasks[0].complete = task1complete
        userManager.user.tasks[2].complete = true
        userManager.updateUser(prRecords: prRecords)
        

        return best.map { ($0.key, $0.value.weight) }
                   .sorted { $0.0 < $1.0 }
    }
        
}
