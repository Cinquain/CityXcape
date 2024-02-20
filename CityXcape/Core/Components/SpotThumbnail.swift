//
//  SpotThumbnail.swift
//  CityXcape
//
//  Created by James Allan on 8/17/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SpotThumbnail: View {
    
    let spot: Location
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: spot.imageUrl))
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(15)
            
            VStack(alignment: .leading, spacing: 10) {
                
                    
                    
            
                Text(spot.name)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                
                HStack(spacing: 3) {
                    Image(systemName: "suit.heart.fill")
                        .foregroundColor(.gray)
                    Text("\(spot.likeCount)")
                        .foregroundColor(.gray)
                        .font(.callout)
                    
                    Image(systemName: "person.2.fill")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    Text("\(spot.checkinCount)")
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.thin)

                    
                    
                }
                .offset(y: -5)
                    
                    HStack(alignment: .bottom, spacing: 3) {
                     
                        Image(systemName: "figure.walk.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .opacity(0.7)
                            .frame(height: 20)
                        
                        Text(spot.distanceString)
                            .font(.callout)
                            .foregroundColor(.white)
                            .fontWeight(.thin)
                        
                        
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                                        
                                
            }
            .padding(.leading, 10)
            
        
            Spacer(minLength: 0)
            
          
        

        }
        .background(Color.black)
    }
    
    func getCheckinText() -> String {
        if spot.checkinCount > 1{
            return "\(spot.checkinCount) inside"
        } else {
            return "\(spot.checkinCount) inside"
        }
    }
}

struct SpotThumbnail_Previews: PreviewProvider {
    static var previews: some View {
        SpotThumbnail(spot: Location(data: Location.data))
            .previewLayout(.sizeThatFits)
    }
}
