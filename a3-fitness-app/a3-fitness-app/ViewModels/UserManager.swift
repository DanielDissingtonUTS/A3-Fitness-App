// UserManager.swift

import Foundation

class UserManager: ObservableObject {
    static let shared = UserManager()

    @Published var user: User = User(name: "",
                                      level: Level(level: 1, xp: 0))

    private let url = URL.documentsDirectory.appending(path: "user.json")

    // CREATE
    func createUser(name: String, level: Level) {
        user = User(name: name, level: level)
        saveUser()
    }

    // READ
    func readUser() {
        do {
            user = try JSONDecoder()
                .decode(User.self, from: Data(contentsOf: url))
        } catch {
            print("Error reading user:", error.localizedDescription)
        }
    }

    // UPDATE
    func updateUser(
        name: String? = nil,
        level: Level? = nil,
        workouts: [Workout]? = nil,
        theme: Theme? = nil,
        tasks: [Task]? = nil
    ) {
        user = User(
            name: name ?? user.name,
            level: level ?? user.level,
            workouts: workouts ?? user.workouts,
            theme: theme ?? user.theme,
            tasks: tasks ?? user.tasks
        )
        saveUser()
    }

    // DELETE
    func deleteUser() {
        do {
            let fm = FileManager.default
            if fm.fileExists(atPath: url.path) {
                try fm.removeItem(at: url)
                user = User(name: "",
                            level: Level(level: 1, xp: 0))
            }
        } catch {
            print("Error deleting user:", error.localizedDescription)
        }
    }

    // SAVE
    func saveUser() {
        do {
            try JSONEncoder()
                .encode(user)
                .write(to: url, options: [.atomic])
        } catch {
            print("Error saving user:", error.localizedDescription)
        }
    }
}
