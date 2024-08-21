//
//  LaunchView.swift
//  CityXcape
//
//  Created by James Allan on 8/9/24.
//

import SwiftUI
import Combine

struct LaunchView: View {
    
    @Binding var showView: Bool
    @State private var loadingText: [String]
    @State private var animateText: Bool = false
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @State private var scale : Int = 1
    
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(showView: Binding<Bool>) {
        self.loadingText = "CityXcape".map({String($0)})
        self._showView = showView
        self.timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    }
    
    var body: some View {
        VStack {
            Spacer()
            bouncingPin()
            Spacer()
                .frame(height: 70)
            Spacer()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear{animateText.toggle()}
        .onReceive(timer, perform: { _ in
            withAnimation(.spring) {
                if loops > 2 {
                    showView = false
                }
                
                if counter == loadingText.count - 1 {
                    counter = 0
                    loops += 1
                }
                counter += 1
            }
        })
    }
    
    
    @ViewBuilder
    func bouncingPin() -> some View {
        HStack(alignment: .center) {
            Spacer()
            VStack {
                Image("Logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .offset(y: loops % 2 == 0 ? -10 : 0)
                
                if animateText {
                    HStack {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundStyle(.orange)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
            }
            Spacer()
        }
    }
    
    
   
}

#Preview {
    LaunchView(showView: .constant(true))
}
