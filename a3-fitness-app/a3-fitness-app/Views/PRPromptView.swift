import SwiftUI

struct PRPromptView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var userManager: UserManager

  var body: some View {
    NavigationStack {
      VStack(spacing: 24) {
        Image(systemName: "checkmark.seal.fill")
          .font(.system(size: 72))
          .foregroundColor(.green)

        Text("Good Job!")
          .font(.largeTitle).bold()

        Text("You’ve completed your workout.")
          .multilineTextAlignment(.center)

        // Direct link into PRs
        NavigationLink("View Your PRs") {
          PRView()
        }
        .font(.headline)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(8)
        .padding(.horizontal)

        Button("Close") {
          dismiss()
        }
        .padding(.top, 12)
      }
      .padding()
    }
    .environmentObject(userManager)
  }
}
