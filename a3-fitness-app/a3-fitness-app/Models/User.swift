import Foundation

struct User: Identifiable, Codable {
    var id = UUID()
    var name: String
    var level: Level
    var workouts: [Workout]?
    var goals: [String] = []
    var goalsDate: Date? = nil             // ← track when they last set goals
    var exercisePool: [Exercise] = []      // ← user’s saved exercises
}
