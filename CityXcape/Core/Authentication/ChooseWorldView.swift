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
    @State private var searchText: String = ""
    var body: some View {
        VStack {
            OnboardingHeader()
            Spacer()
            VStack {
                Text("Which Communities are You Part of?")
                    .font(.title3)
                    .fontWeight(.light)
                    .foregroundStyle(.white)
                    .alert(isPresented: $vm.showError, content: {
                        Alert(title: Text(vm.errorMessage))
                    })
                
                
                    ScrollView {
                        ForEach(vm.worlds.sorted(by: {$0.name < $1.name})) { world in
                            Button {
                                vm.addOrRemove(world: world)
                                if vm.selectedWorlds.count == 3 {
                                    isDone = true
                                } else {
                                    isDone = false 
                                }
                            } label: {
                                worldItem(world: world)
                            }
                        }
                    }
                    .frame(height: 500)
                    .searchable(text: $searchText)
                
                
              
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
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vm.city)
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
    
    fileprivate func submitWorlds() {
        if vm.selectedWorlds.isEmpty {
            vm.errorMessage = "Please choose at least one world"
            vm.showError.toggle()
        }
        vm.subbmitWorlds()
        withAnimation {
            index = 6
        }
    }
    
    
    

    
}

#Preview {
   Onboarding()
}
