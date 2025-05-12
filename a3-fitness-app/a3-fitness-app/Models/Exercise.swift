struct Exercise: Codable, Identifiable, Hashable, Equatable {
    var id: String {
        return exerciseId
    }
    let exerciseId: String
    let name: String
    let gifUrl: String
    let targetMuscles: [String]
    let bodyParts: [String]
    let equipments: [String]
    let secondaryMuscles: [String]
    let instructions: [String]
}
