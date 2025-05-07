import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    var name: String
    var level: Level
    var workouts: [Workout]?
    var goals: [String] = []      // ← default empty, will be set in UserGoalsView
}
