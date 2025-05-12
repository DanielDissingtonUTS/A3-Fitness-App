// UserManager.swift

import Foundation

class UserManager: ObservableObject {
    static let shared = UserManager()

    @Published var user: User = User(name: "", level: Level(level: 1, xp: 0))

    private let url = URL.documentsDirectory.appending(path: "user.json")

    // CREATE
    func createUser(name: String, level: Level) {
        let tasks: [Task] = [
            Task(description: TaskDetails.description[0], xp: 100, complete: false),
            Task(description: TaskDetails.description[1], xp: 200, complete: false),
            Task(description: TaskDetails.description[2], xp: 310, complete: false)
        ]
        
        user = User(name: name, level: level, tasks: tasks)
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
        prRecords: [PRRecord]? = nil,
        tasks: [Task]? = nil
    ) {
        user = User(
            name: name ?? user.name,
            level: level ?? user.level,
            workouts: workouts ?? user.workouts,
            theme: theme ?? user.theme,
            prRecords: prRecords ?? user.prRecords,
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
