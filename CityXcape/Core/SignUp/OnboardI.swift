//
//  OnboardI.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI

struct OnboardI: View {
    var body: some View {

        GeometryReader {
            let size = $0.size
            
            VStack {
                Text("NAME YOUR WORLD")
                    .font(.title2)
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .tracking(8)
                    .padding(.top, 60)
                Text("Give your world a recognizebale name")
                    .font(.callout)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .fontWeight(.thin)
                Spacer()
                
              
            }
            .frame(width: size.width, height: size.height)
            .background(Background())
        }
        .edgesIgnoringSafeArea(.all)

    }
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            Image("globe_background")
                .resizable()
                .scaledToFill()
                .overlay {
                    ZStack {
                        Rectangle()
                            .fill(.linearGradient(colors: [
                                .black.opacity(0.1),
                                .black.opacity(0.2),
                                .black.opacity(0.2),
                                .black.opacity(0.8),
                                .black], startPoint: .bottom, endPoint: .top))
                    }
                }
        }
    }
}

struct OnboardI_Previews: PreviewProvider {
    static var previews: some View {
        OnboardI()
    }
}
