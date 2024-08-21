//
//  TimerViewModel.swift
//  CityXcape
//
//  Created by James Allan on 8/16/24.
//

import Foundation


class TimerViewModel: ObservableObject {
    
    @Published var finalValue: CGFloat = 0
    @Published var count: Int = 60
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var minutes: Int = 10
    @Published var seconds: Int = 0
    @Published var beginTimer: Bool = false
    
    @Published var timerString: String = ""
    @Published var totalSeconds: Int = 0
    @Published var staticTotalSeconds: Int = 0
    
    @Published var isExpired: Bool = false
    @Published var showPass: Bool = false
    
    
    func startTimer() {
        beginTimer = true
        timerString = "\(minutes):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"
        totalSeconds = (minutes * 60) + seconds
        staticTotalSeconds = totalSeconds
    }
    
    func updateTimer() {
        totalSeconds -= 1
        finalValue = CGFloat(totalSeconds) / CGFloat(staticTotalSeconds)
        finalValue = finalValue < 0 ? 0 : finalValue
        minutes = (totalSeconds / 60)
        seconds = (totalSeconds % 60)
        timerString = "\(minutes):\(seconds >= 10 ? "\(seconds)" : "0\(seconds)")"

        if minutes == 0 && seconds == 0 {
            stopTimer()
        }

    }
    
    func stopTimer() {
        beginTimer = false
        isExpired = true 
        minutes = 0
        seconds = 0
        finalValue = 1
        totalSeconds = 0
        staticTotalSeconds = 0
        timerString = "0:00"
        timer.upstream.connect().cancel()
        
    }
}
