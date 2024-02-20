//
//  LaunchView.swift
//  CityXcape
//
//  Created by James Allan on 1/27/24.
//

import SwiftUI
import Combine

struct LaunchView: View {
    
    @Binding var showLaunchView: Bool
    @State private var loadingText: [String]
    
    
    @State private var showLoadingText: Bool = false
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @State private var scale: Int = 1
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init(message: String, showView: Binding<Bool>) {
        self.loadingText = message.map({String($0)})
        self._showLaunchView = showView
        self.counter = 0
        self.loops = 0
        self.scale = 1
        self.timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack {
                    Image("Fire Pin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .offset(y: loops % 2 == 0 ? -10 : 0)

                    if showLoadingText {
                        HStack {
                            ForEach(loadingText.indices) { index in
                                Text(loadingText[index])
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .foregroundColor(.orange)
                                    .offset(y: counter == index ? -5 : 0)
                            }
                        }
                        .transition(AnyTransition.scale.animation(.easeIn))

                    }
                }

              
                Spacer()
            }
            Spacer()
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear{showLoadingText.toggle()}
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                if loops > 2 {
                    showLaunchView = false
                }
                
                if counter == loadingText.count - 1 {
                    counter = 0
                    loops += 1
                }
                counter += 1

            }
        }
    }

}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(message: "Loading Las Vegas", showView: .constant(true))
    }
}
