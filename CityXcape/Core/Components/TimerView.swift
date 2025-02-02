//
//  TimerView.swift
//  CityXcape
//
//  Created by James Allan on 8/16/24.
//

import SwiftUI

struct TimerView: View {
    
    
    @StateObject var vm = TimerViewModel()
    let size: CGFloat
    let thickness: CGFloat
    let font: Font
    
    var body: some View {
        
        VStack(spacing: 25) {
            ZStack {
                Circle()
                    .trim(from: 0, to: 1)
                    .stroke(Color.gray.opacity(0.2), style: StrokeStyle(lineWidth: thickness, lineCap: .round))
                    .frame(width: size, height: size)
                
                Circle()
                    .trim(from: 0, to: vm.finalValue)
                    .stroke(Color.blue.opacity(0.8), style: StrokeStyle(lineWidth: thickness, lineCap: .round))
                    .frame(width: size, height: size)
                    .rotationEffect(.init(degrees: -90))
                
                Text(vm.timerString)
                    .font(font)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    
                    
            }
            .onAppear(perform: {
                withAnimation {
                    vm.startTimer()
                }
            })
            .onReceive(vm.timer, perform: { _ in
                withAnimation {
                    vm.updateTimer()
                }
        })
            
           
        }
    }
    
    
}

#Preview {
    VStack {
        Spacer()
        HStack {
            Spacer()
            TimerView(size: 250, thickness: 30, font: .title)
            Spacer()
        }
        Spacer()
    }
    .background(.black)
}
