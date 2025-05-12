import Foundation

func fetchExercises(limit: Int = 10) async throws -> [Exercise] {
    
    guard let url = URL(string: "https://exercisedb-api.vercel.app/api/v1/exercises?limit=\(limit)") else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url) // '_' is response code (200, 404, etc.)
    
// Print raw JSON to show DB structure
//    if let jsonString = String(data: data, encoding: .utf8) {
//            print(jsonString)
//    }
    
    let decoded = try JSONDecoder().decode(ExerciseResponse.self, from: data) // Decode 
    return decoded.data.exercises
}
