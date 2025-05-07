import SwiftUI

struct UserGoalsView: View {
    @StateObject var userManager: UserManager
    @Binding    var isSettingGoals: Bool

    // Your 10 goal options
    let goalOptions = [
      "Upper Body Strength",
      "Lower Body Strength",
      "Core Strength",
      "Full-Body Strength",
      "Explosive Power",
      "Full-Body Cardio",
      "HIIT Cardio",
      "Endurance Cardio",
      "Mobility & Flexibility",
      "Specialty Focus"
    ]

    // Use Swift’s Set<String>, not your custom `Set` type
    @State private var selected: Swift.Set<String> = []

    var body: some View {
        NavigationStack {
            List(goalOptions, id: \.self) { goal in
                MultipleSelectionRow(
                    title:      goal,
                    isSelected: selected.contains(goal)
                ) {
                    if selected.contains(goal) {
                        selected.remove(goal)
                    } else {
                        selected.insert(goal)
                    }
                }
            }
            .navigationTitle("Pick Your Goals")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Continue") {
                        // Save to user and persist
                        userManager.user.goals = Array(selected)
                        userManager.saveUser()
                        // Dismiss
                        isSettingGoals = false
                    }
                    .disabled(selected.isEmpty)
                }
            }
        }
    }
}

struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

struct UserGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        UserGoalsView(
            userManager:    UserManager(),
            isSettingGoals: .constant(true)
        )
    }
}
