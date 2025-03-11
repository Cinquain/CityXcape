//
//  TimerView.swift
//  CityXcape
//
//  Created by James Allan on 8/16/24.
//

import SwiftUI

struct CircularProgressView: View {
    
    
    let size: CGFloat
    let thickness: CGFloat
    let font: Font
    let value: Int
    
    @State private var color: Color = .orange
    @State private var fontColor: Color = .white
    
    @State private var finalValue: CGFloat = 0
    var body: some View {
        
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: thickness, lineCap: .round))
                    .frame(width: size, height: size)
                
                Circle()
                    .trim(from: 0, to: finalValue)
                    .stroke(color.opacity(0.8), style: StrokeStyle(lineWidth: thickness, lineCap: .round))
                    .frame(width: size, height: size)
                    .rotationEffect(.init(degrees: -90))
                
                Text("\(value)% \n Match")
                    .font(font)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(fontColor)
                    
                    
            }
        
            
           
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                finalValue = CGFloat(value) / 100.0
                if value >= 50 {
                    color = .green
                }
                
                if value == 100 {
                    fontColor = .green
                }
                
            }
        }
    }
    
    
}

#Preview {
    VStack {
        Spacer()
        HStack {
            Spacer()
            CircularProgressView(size: 250, thickness: 30, font: .title, value: 100)
            Spacer()
        }
        Spacer()
    }
    .background(.black)
}
