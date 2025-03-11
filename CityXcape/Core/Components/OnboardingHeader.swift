//
//  OnboardingHeader.swift
//  CityXcape
//
//  Created by James Allan on 11/7/24.
//

import SwiftUI

struct OnboardingHeader: View {
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(LocationService.shared.city)
                        .font(.caption)
                        .fontWeight(.thin)
                        .foregroundStyle(.white)
                        .tracking(4)
                    
                    Text("STREETPASS")
                        .font(.system(size: 24))
                        .fontWeight(.thin)
                        .tracking(4)
                        .opacity(0.7)
                    
                }
                .foregroundStyle(.white)
                Spacer()
                
            }
            .padding(.horizontal, 20)
        
    }
}

#Preview {
    OnboardingHeader()
}
