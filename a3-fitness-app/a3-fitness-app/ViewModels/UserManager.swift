import Foundation

class UserManager: ObservableObject {
    
    @Published var user: User = User(name: "", level: Level(level: 1, xp: 0))
    
    private let url = URL.documentsDirectory.appending(path: "user.json")
    
    // CREATE
    func createUser(name: String, level: Level) {
        self.user = User(name: name, level: level)
        do {
            try JSONEncoder().encode(self.user).write(to: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // READ
    func readUser() {
        do {
            self.user = try JSONDecoder()
                .decode(User.self, from: Data(contentsOf: url))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // UPDATE
    func updateUser(name: String, level: Level, workouts: [Workout]?) {
        self.user = User(name: name, level: level, workouts: workouts)
        do {
            try JSONEncoder()
                .encode(self.user)
                .write(to: url, options: [.atomic])
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // DELETE
    func deleteUser() {
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
    
    // SAVE
    /// Persist the current `user` back to disk.
    func saveUser() {
        do {
            try JSONEncoder()
                .encode(self.user)
                .write(to: url, options: [.atomic])
        } catch {
            print("Error saving user:", error.localizedDescription)
        }
    }
}
