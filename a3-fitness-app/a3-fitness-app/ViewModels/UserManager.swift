import Foundation

class UserManager: ObservableObject {
    
    @Published var user: User = User(name: "", level: Level(level: 1, xp: 0))
    
    private let url = URL.documentsDirectory.appending(path: "user.json")
    
    func createUser(name: String, level: Level) { // CREATE
        self.user = User(name: name, level: level)
        
        do {
            try JSONEncoder().encode(self.user).write(to: url)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readUser() { // READ
        do {
            self.user = try JSONDecoder().decode(User.self, from: Data(contentsOf: url))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateUser(name: String, level: Level, workouts: [Workout]?) { // UPDATE
        self.user = User(name: name, level: level, workouts: workouts)
            
        do {
            try JSONEncoder().encode(self.user).write(to: url, options: [.atomic])
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteUser() { // DELETE
        do {
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
                self.user = User(name: "", level: Level(level: 1, xp: 0))
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
