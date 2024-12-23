//
//  ChooseWorldView.swift
//  CityXcape
//
//  Created by James Allan on 9/24/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChooseWorldView: View {

    @State private var isDone: Bool = false
    @StateObject var vm: UploadViewModel
    @Binding var index: Int

    var body: some View {
        VStack {
            OnboardingHeader()
            Spacer()
            VStack {
                Text("Choose Up to 3 Worlds")
                    .font(.title)
                    .fontWeight(.light)
                    .foregroundStyle(.white)
                    .alert(isPresented: $vm.showError, content: {
                        Alert(title: Text(vm.errorMessage))
                    })
                Text("Worlds are communities people belong to")
                    .font(.callout)
                    .fontWeight(.light)
                    .foregroundStyle(.white)
                  
                
                    ScrollView {
                        ForEach(vm.worlds.sorted(by: {$0.name < $1.name})) { world in
                            Button {
                                vm.addOrRemove(world: world)
                                if !vm.selectedWorlds.isEmpty {
                                    isDone = true
                                } else {
                                    isDone = false 
                                }
                            } label: {
                                worldItem(world: world)
                            }
                        }
                    }
                    .frame(height: 400)
                
                
              
            }
            
            Button(action: {
              submitWorlds()
            }, label: {
                Label("Done", systemImage: "checkmark.shield.fill")
                    .foregroundStyle(.white)
                    .fontWeight(.light)
                    .frame(width: 125, height: 35)
                    .background(isDone ? .green : .gray)
                    .animation(.easeIn, value: isDone)
                    .clipShape(Capsule())
            })
            .padding(.top, 45)
            
            Spacer()

        }
        .background(SPBackground())
        .onAppear(perform: {
            vm.getWorlds()
        })

    }
    
    
    @ViewBuilder
    func worldItem(world: World) -> some View {
        HStack(spacing: 20) {
            WebImage(url: URL(string: world.imageUrl))
                .resizable()
                .scaledToFit()
                .frame(height: 80)
            Text(world.name)
                .font(.title)
                .foregroundStyle(.white)
                .fontWeight(.thin)
            Spacer()
            Image(systemName: vm.selectedWorlds.contains(world) ? "checkmark.circle" : "circle")
                .foregroundColor(.white)
                .padding(.trailing, 10)
        }
        .contentMargins(10)
        .cornerRadius(12)

    }
    
    func submitWorlds() {
        if vm.selectedWorlds.isEmpty {
            vm.errorMessage = "Please choose at least one world"
            vm.showError.toggle()
        }
        withAnimation {
            index = 6
        }
    }
    
    
    

    
}

#Preview {
   Onboarding()
}
