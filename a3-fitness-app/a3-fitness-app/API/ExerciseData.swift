struct ExerciseData: Codable {
    let previousPage: String?
    let nextPage: String?
    let totalPages: Int
    let totalExercises: Int
    let currentPage: Int
    let exercises: [Exercise]
}
