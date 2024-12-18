//
//  MessagesView.swift
//  CityXcape
//
//  Created by James Allan on 9/16/24.
//

import SwiftUI

struct MessagesView: View {
    
    @StateObject var vm : ChatViewModel
    @State var currentMessage : Message?
    var body: some View {
        
            VStack {
                header()
                ScrollView {
                    ForEach(vm.recents) { message in
                       
                        Button {
                            currentMessage = message
                        } label: {
                            ChatPreview(message: message)
                        }
                        .sheet(item: $currentMessage) { message in
                            Chatroom(message: message, vm: vm)
                        }

                    }
                }
                Spacer()
            }
            .navigationBarHidden(true)
            .toolbar(.visible, for: .tabBar)
            .background(HexBackground())
           

    }
    
    
    @ViewBuilder
    func header() -> some View {
        HStack(spacing: 5) {
            Spacer()
            Image("dot")
                .resizable()
                .scaledToFit()
                .frame(height: 25)
            Text("MESSAGES")
                .fontWeight(.thin)
                .tracking(3)
            Spacer()
        }
        .background(.black)
        .padding(.bottom, 25)
        
    }
}

#Preview {
    MessagesView(vm: ChatViewModel())
}
