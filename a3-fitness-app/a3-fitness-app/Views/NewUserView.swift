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
                    
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size * 0.8, height: size * 0.8)
                    
                    Text("Enter your name:")
                        .font(.title)
                    
                    TextField("", text: $userManager.user.name)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .background (
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .padding(.bottom)
                        .frame(maxWidth: width * 0.8)
                        .onReceive(Just(userManager.user.name)) { char in
                            if char.count > 20 { // This works when a real User object is fed in
                                userManager.user.name = String(char.prefix(20))
                            }
                        }
                    
                    Spacer()
                    
                    Button("Save") {
                        userManager.createUser(name: userManager.user.name, level: Level(level: 2, xp: 0)) // Changed to lvl 2 for testing
                        print(userManager.user.name)
                        isNewUser = false
                    }
                    .disabled(userManager.user.name.isEmpty)
                        .font(.title)
                        .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    NewUserView(isNewUser: Binding.constant(true))
        .environmentObject(UserManager.shared)
}

