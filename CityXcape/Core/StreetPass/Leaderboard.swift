//
//  RankingsView.swift
//  CityXcape
//
//  Created by James Allan on 3/8/25.
//

import SwiftUI

struct Leaderboard: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: StreetPassViewModel
    
    @State var max: Float = 0
    
    var body: some View {
        VStack {
            header()
            
            ScrollView {
                
                ForEach(vm.ranks) { rank in
                    RankingItem(rank: rank, max: max, number: (vm.ranks.firstIndex(of: rank) ?? 0) + 1)
                    Divider()
                        .frame(height: 0.5)
                        .foregroundStyle(.white)
                }
                
               
            }
            Spacer()
            closeButton()
            
        }
        .background(background())
        .onAppear {
            max = vm.ranks.sorted(by: {$0.totalSales > $1.totalSales}).first?.totalSales ?? 0
        }
    }
    
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Spacer()
            Image(systemName: "crown.fill")
                .font(.title)
                .foregroundStyle(.white)
            Text("Top Scouts")
                .font(.title)
                .fontWeight(.thin)
                .foregroundStyle(.white)
            Spacer()
        }
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            
            Image("honeycomb-blue")
                .resizable()
                .scaledToFit()
                .opacity(0.3)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func closeButton() -> some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.down")
                .font(.system(size: 50))
                .foregroundStyle(.white)
                .fontWeight(.thin)
        }
        .padding(.bottom, 10)

    }
}

#Preview {
    Leaderboard(vm: StreetPassViewModel())
}
