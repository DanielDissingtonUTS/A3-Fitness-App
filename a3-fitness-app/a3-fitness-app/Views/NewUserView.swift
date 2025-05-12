import SwiftUI
import Combine

struct NewUserView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var isNewUser: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let size = min(width, height)
            
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image("FitXPLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size * 0.6, height: size * 0.6)
                    Spacer()
                    
                    Text("Enter username:")
                        .font(Font.custom("ZenDots-Regular", size: 20))
                        .padding()
                    
                    
                    TextField("", text: $userManager.user.name)
                        .padding()
                        .multilineTextAlignment(.center)
                        .font(Font.custom("ZenDots-Regular", size: 20))
                        .background (
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .padding(.bottom)
                        .frame(maxWidth: width * 0.8)
                        .onReceive(Just(userManager.user.name)) { char in
                            if char.count > 20 { // This works when a real User object is fed in
                                userManager.user.name = String(char.prefix(15))
                            }
                        }
                    
                    Spacer()
                    
                    Button("Continue") {
                        userManager.createUser(name: userManager.user.name, level: Level(level: 2, xp: 0)) // Changed to lvl 2 for testing
                        generateTasks()
                        isNewUser = false
                    }
                    .disabled(userManager.user.name.isEmpty)
                    .font(Font.custom("ZenDots-Regular", size: 20))
                    .padding(.vertical, 12) 
                    .padding(.horizontal, 20)
                    .buttonStyle(.borderedProminent)
                    
                    
                    Spacer()
                }
            }
        }
    }
    
    private func generateTasks() {
        var newTasks: [Task] = []

        for i in 0..<3 {
            newTasks.append(Task(description: TaskDetails.description[i], xp: TaskDetails.xp[i], complete: false))
        }
        
        userManager.updateUser(tasks: newTasks)
    }
}

#Preview {
    NewUserView(isNewUser: Binding.constant(true))
        .environmentObject(UserManager.shared)
}

