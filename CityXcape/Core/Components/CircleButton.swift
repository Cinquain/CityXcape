//
//  CircleButton.swift
//  CityXcape
//
//  Created by James Allan on 8/2/24.
//

import SwiftUI

struct CircleButton: View {
    
    @State private var animate: Bool = false
    
    var perform: () -> ()
    var systemName: String
    var activeTint: Color
    var inactiveTint: Color
    
    var body: some View {
        Button(action: {
            animate.toggle()
            perform()
        }, label: {
            Image(systemName: systemName)
                .font(.title2)
                .foregroundStyle(animate ? activeTint : .white)
                .particleEffect(
                    systemName: systemName,
                    font: .title2,
                    status: animate,
                    activeTint: activeTint,
                    inactiveTint: inactiveTint)
                .frame(width: 60, height: 60)
                .background(animate ? activeTint.opacity(0.25) : inactiveTint)
                .clipShape(Circle())
                .scaleEffect(animate ? 0.9 : 1)
        })
    }
}

#Preview {
    CircleButton(perform: {}, systemName: "info.circle.fill", activeTint: .purple, inactiveTint: .blue)
}
