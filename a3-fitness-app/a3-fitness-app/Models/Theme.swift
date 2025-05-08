import SwiftUI

struct Theme: Codable, Equatable {
    var name: String
    var primaryColor: String
    var secondaryColor: String
    var tertiaryColor: String
    var requiredLevel: Int
    var unlocked: Bool
}
