//
//  XPView.swift
//  a3-fitness-app
//
//  Created by Daniel Dissington on 2/5/2025.
//

import SwiftUI

struct XPView: View {
    let level: Int
    let progress: Float
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack(alignment: .leading) {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: width * 0.8, height: height * 0.1)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green)
                        .frame(width: (width * 0.8) * CGFloat(progress), height: height * 0.05)
                }
                .offset(x: width * 0.2)
                
                Text(String(level))
                    .font(.system(size: size * 0.12, weight: .bold))
                    .frame(width: width * 0.2, height: height * 0.1)
                    .background(Color.gray)
                    .position(x: width * 0.1, y: height / 2)
            }
        }
    }
}

#Preview {
    XPView(level: 1, progress: 0.5)
}
