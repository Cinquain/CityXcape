//
//  ChatPreview.swift
//  CityXcape
//
//  Created by James Allan on 9/16/24.
//

import SwiftUI

struct ChatPreview: View {
    
    var message: Message
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                UserDot(size: 60, url: message.imageUrl)
                    .padding(.top,2)
                VStack(alignment: .leading) {
                    Text(message.username)
                        .font(.callout)
                        .foregroundStyle(.white)
                        .fontWeight(.light)
                    
                    Text(message.content)
                        .foregroundStyle(.white)
                        .fontWeight(.thin)
                        .lineLimit(1)
                }
                Spacer()
                
             
            }
            
            
            Divider()
                .frame(height: 0.5)
                .background(.white)
                .padding(.leading, 80)
        }
        .padding(.horizontal)
        .background(.black)
        
    }
    
    
}

#Preview {
    ChatPreview(message: Message.demo)
}
