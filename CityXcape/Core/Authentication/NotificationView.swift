//
//  NotificationView.swift
//  CityXcape
//
//  Created by James Allan on 12/18/24.
//

import SwiftUI

struct NotificationView: View {
    
    @StateObject var vm: UploadViewModel
    @StateObject var manager = NotificationManager.shared
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    @Binding var index: Int
    
    var body: some View {
        VStack {
            header()
            Spacer()
                .frame(height: 200)
            
            VStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .foregroundStyle(.white)
                    .font(.system(size: 70))
                Text("Get Notified when users \n send you a messgae")
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
            }
                       
            Button(action: {
                manager.requestAuthorization()
            }, label: {
                Text("Enable Notification")
                    .foregroundStyle(.white)
                    .font(.callout)
                    .frame(width: 220, height: 40)
                    .background(.blue)
                    .clipShape(Capsule())
            })
            .padding(.top, 10)
            .alert(isPresented: $showError, content: {
                return Alert(title: Text(errorMessage))
            })
            
            Button(action: {
                if manager.granted {
                    withAnimation {
                        index = 3
                    }
                } else {
                    errorMessage = "Please enable notifications"
                    showError.toggle()
                }
            }, label: {
                Label("Done", systemImage: "checkmark.shield.fill")
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .frame(width: 125, height: 35)
                    .background(manager.granted ? .green : .gray)
                    .animation(.easeIn, value: manager.granted)
                    .clipShape(Capsule())
            })
            .padding(.top, 45)
            
            Spacer()
        }
        .background(SPBackground())
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("")
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
    Onboarding()
}
