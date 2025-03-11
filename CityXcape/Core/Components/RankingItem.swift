//
//  RankingItem.swift
//  CityXcape
//
//  Created by James Allan on 3/8/25.
//

import SwiftUI

struct RankingItem: View {
    
    var rank: UserRank
    var max: Float
    var number: Int
    @State private var progress: Float = 0
    var body: some View {
        HStack {
            
            SelfieBubble(size: 80, url: rank.imageUrl, pulse: 1)
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("#\(number)")
                        .font(.caption)
                        .fontWeight(.thin)
                        .foregroundStyle(.white)
                    Text(rank.username)
                        .fontWeight(.thin)
                        .foregroundStyle(.white)
                }
               
                
                ProgressView(value: progress, total: max)
                    .progressViewStyle(.linear)
                    
            }
            
            VStack {
                Text("$\(String(format: "%.0f", rank.totalSales))")
                    .font(.title3)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                
                Text("\(rank.totalSpots) spots")
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
            }
            
            
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6)) {
                progress = Float(rank.totalSales)

            }
        }
    }
}

#Preview {
    RankingItem(rank: UserRank.demo, max: 10000, number: 1)
}
