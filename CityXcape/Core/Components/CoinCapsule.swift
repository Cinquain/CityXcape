//
//  CoinCapsule.swift
//  CityXcape
//
//  Created by James Allan on 8/14/24.
//

import SwiftUI

struct CoinCapsule: View {
    let count: Int
    let price: Double

    var body: some View {
        Text("\(count) Connections for $\(roundedNumber())")
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .frame(width: 275, height: 50)
            .background(.orange.opacity(0.6))
            .clipShape(Capsule())
    }
    
    
    func roundedNumber() -> String {
        return String(format: "%.2f", price)
    }
}

#Preview {
    CoinCapsule(count: 10, price: 9.99)
}
