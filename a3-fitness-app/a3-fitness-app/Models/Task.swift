import SwiftUI

struct Task: Codable, Equatable, Identifiable {
    let id = UUID()
    var exercise: Exercise
    var description: String
    var xp: Int
    var complete: Bool
}
