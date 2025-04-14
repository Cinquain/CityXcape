//
//  SoundManager.swift
//  CityXcape
//
//  Created by James Allan on 8/2/24.
//

import Foundation
import AVKit



final class SoundManager {
    
    static let shared = SoundManager()
    private init() {}
    
    var player: AVAudioPlayer?
    
    func playStamp() {
        guard let url = Bundle.main.url(forResource: "Stamp", withExtension: ".mp3") else {return}
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error playing stamp sound", error.localizedDescription)
        }
    }
}
