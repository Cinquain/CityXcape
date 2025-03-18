//
//  AnalyticsView.swift
//  CityXcape
//
//  Created by James Allan on 3/10/25.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var vm: StreetPassViewModel

    var body: some View {
        VStack {
            header()
            
            Chart(vm.uploads, id: \.name) {
                      BarMark(
                          x: .value("Impact", $0.name),
                          y: .value("Total", $0.totalSales))
                  

                  }
                  .frame(height: 300)
                  .foregroundColor(.blue)
                  .colorScheme(.dark)
                  .padding(.top, 40)
            
            HStack {
               
                Text("Top Earning Locations")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .fontWeight(.thin)
            }
            checkinCount()
            
            
            Spacer()
            showRanksButton()
        }
        .background(SPBackground())
    }
    
    @ViewBuilder
    func background() -> some View {
        ZStack {
            Color.black
            Image("orange-paths")
                .resizable()
                .scaledToFill()
                .rotationEffect(Angle(degrees: 180))
                .opacity(0.8)
               
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Text("Street Report Card")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.thin)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.square.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
      func checkinCount() -> some View {
          
          ScrollView {
              ForEach(vm.uploads.sorted(by: {$0.totalSales > $1.totalSales})) { spot in
                  Button(action: {
                     //Load analytics page
                  }, label: {
                      HStack {
                          Image("Pin")
                              .resizable()
                              .scaledToFit()
                              .frame(height: 30)
                          Text(spot.name)
                              .fontWeight(.thin)
                              .foregroundColor(.white)
                          Spacer()
                          
                          Text("\(String(format: "$%.2f", spot.totalSales))")
                              .foregroundColor(.white)
                              .font(.callout)
                              .fontWeight(.thin)
                      }
                  })
                  .padding(.horizontal, 20)
                 
                  
                  Divider()
                      .foregroundColor(.white)
                      .frame(height: 0.5)
                 
              }
          }
          .padding(.top, 40)
      }
    
    @ViewBuilder
    func showRanksButton() -> some View {
        Button {
            vm.getLeaderBoard()
        } label: {
            Text("Leaderboard")
                .foregroundStyle(.white)
                .fontWeight(.thin)
                .frame(width: 180, height: 35)
                .background(.blue)
                .clipShape(Capsule())
        }
        .padding(.bottom, 4)
        .fullScreenCover(isPresented: $vm.showRanks) {
            Leaderboard(vm: vm)
        }
    }
    
}

#Preview {
    AnalyticsView(vm: StreetPassViewModel())
}
