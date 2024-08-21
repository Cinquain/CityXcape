//
//  BlurView.swift
//  CityXcape
//
//  Created by James Allan on 8/10/24.
//

import Foundation
import SwiftUI



struct BlurView: UIViewRepresentable {
    
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        //No Update Code required
    }
}
