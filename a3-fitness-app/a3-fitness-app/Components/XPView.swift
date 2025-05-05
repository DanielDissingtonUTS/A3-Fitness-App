import SwiftUI

struct XPView: View {
    let level: Level
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let size = min(width, height)
            
            ZStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: width * 0.8, height: height * 0.1)
                    RoundedRectangle(cornerRadius: width * 0.02)
                        .fill(Color.red)
                        .frame(width: (width * 0.75) * 1, height: height * 0.05)
                    RoundedRectangle(cornerRadius: width * 0.02)
                        .fill(Color.green)
                        .frame(width: (width * 0.75) * CGFloat(level.progress), height: height * 0.05)
                }
                    .offset(x: width * 0.2)
                
                Text(String(level.level))
                    .font(.system(size: size * 0.12, weight: .bold))
                    .frame(width: width * 0.2, height: height * 0.1)
                    .background(Color.gray)
                    
                
                Text(String("\(level.xp) / \(level.level * 100) XP"))
                    .font(.system(size: size * 0.12, weight: .bold))
                    .frame(width: width, height: height * 0.1)
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .offset(y: height * 0.1)
            }
            .position(x: width / 2, y: height / 2)
        }
    }
}

#Preview {
    XPView(level: Level(level: 1, xp: 50))
}
