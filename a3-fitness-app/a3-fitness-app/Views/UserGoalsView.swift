import SwiftUI

struct UserGoalsView: View {
    @ObservedObject var userManager: UserManager
    @Binding       var isSettingGoals: Bool

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

    @State private var selected: Set<String> = []

    var body: some View {
        NavigationStack {
            List(goalOptions, id: \.self) { goal in
                MultipleSelectionRow(
                    title: goal,
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
                        // 1) Copy the struct
                        var copy = userManager.user
                        copy.goals     = Array(selected)
                        copy.goalsDate = Date()

                        // 2) Re-assign to the published property
                        userManager.user = copy

                        // 3) Persist
                        userManager.saveUser()

                        // 4) Dismiss sheet
                        isSettingGoals = false
                    }
                    .disabled(selected.isEmpty)
                }
            }
        }
    }
}

//— Helper row
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
