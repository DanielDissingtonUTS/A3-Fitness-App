// ExerciseSet.swift (formerly Set.swift)
struct ExerciseSet: Codable {
  var exercises: [Exercise]
  var targetReps: Int
  var totalReps: Int?
  var weight: Double?
}
