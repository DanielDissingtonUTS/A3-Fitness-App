import SwiftUI
import Combine

struct NewUserView: View {
    @Binding var user: User
    @Binding var userInvalid: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Image("Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width * 0.8, height: width * 0.8)
                    
                    Text("Enter your name:")
                        .font(.title)
                    
                    TextField("", text: $user.name)
                        .multilineTextAlignment(.center)
                        .padding()
                        .font(.title2)
                        .background (
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.horizontal)
                        .padding(.bottom)
                        .frame(maxWidth: width * 0.8)
                        .onReceive(Just(user.name)) { char in
                            if char.count > 20 {
                                user.name = String(char.prefix(20))
                            }
                        }
                    
                    Spacer()
                    
                    Button("Save") {
                        userInvalid = false
                    }
                        .disabled(user.name.isEmpty)
                        .font(.title)
                        .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
            }
        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    @State static var user = User(name: "", level: Level(level: 1, xp: 0))
    @State static var userInvalid = true
    
    static var previews: some View {
        NewUserView(user: $user, userInvalid: $userInvalid)
    }
}
