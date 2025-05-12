import SwiftUI

struct Task: Codable, Equatable, Identifiable {
    let id = UUID()
    var description: String
    var xp: Int
    var complete: Bool
}
