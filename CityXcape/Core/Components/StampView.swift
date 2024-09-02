//
//  StampView.swift
//  CityXcape
//
//  Created by James Allan on 8/1/24.
//

import SwiftUI

struct StampView: View {
    let name: String
    let day = Date.formattedDate(Date())
    let time = Date.timeFormatter(Date())
    
    @State private var animate: Bool = true
    
    var body: some View {
       Image("Stamp")
            .resizable()
            .scaledToFit()
            .frame(width: 305)
            .overlay(timestamp())
            .scaleEffect(animate ? 4 : 1)
            .rotationEffect(animate ? Angle(degrees: 0) : Angle(degrees: -35))
            .animation(.easeIn(duration: 0.25), value: animate)
            .animation(.spring(), value: animate)
            .onAppear(perform: {
                SoundManager.shared.playStamp()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                    self.animate.toggle()
                })
            })
    }
    
    @ViewBuilder
    func timestamp() -> some View {
        VStack(alignment: .center, spacing: 0) {
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
            
            Text(day())
                .font(.title3)
                .fontWeight(.medium)
            
            Text(time())
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(.red)
        .rotationEffect(Angle(degrees: -32))
    }
    
    

    
    
    
    
}

#Preview {
    StampView(name: "Graffiti Pier")
}
