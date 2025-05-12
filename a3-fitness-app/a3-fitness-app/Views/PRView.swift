import SwiftUI

struct PRView: View {
    @EnvironmentObject var userManager: UserManager

    /// Builds a list of (exercise name → max weight) pairs
    private var records: [(String, Double)] {
        guard let workouts = userManager.user.workouts else { return [] }
        var best: [String: Double] = [:]
        for w in workouts {
            for set in w.sets {
                let name = set.exercises.first?.name ?? "Unknown"
                if let wt = set.weight {
                    best[name] = max(best[name] ?? 0, wt)
                }
            }
        }
        return best.map { ($0.key, $0.value) }
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
    }
}
