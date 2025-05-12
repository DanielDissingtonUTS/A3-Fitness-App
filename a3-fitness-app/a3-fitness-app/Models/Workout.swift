// Workout.swift

import Foundation

/// A named workout, which bundles exercises with their sets
struct Workout: Codable {
    var name: String
    var exercises: [Exercise]
    /// Changed from `[Set]` to `[ExerciseSet]`
    var sets: [ExerciseSet]
}
