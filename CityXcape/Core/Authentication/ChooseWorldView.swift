//
//  ChooseWorldView.swift
//  CityXcape
//
//  Created by James Allan on 9/24/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChooseWorldView: View {

    
    @StateObject var vm: UploadViewModel
 
    var body: some View {
        VStack {
            header()
            Spacer()
            VStack {
                Text("Choose Up to 3 Worlds")
                    .font(.title)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .alert(isPresented: $vm.showError, content: {
                        Alert(title: Text(vm.errorMessage))
                    })
                Text("Worlds are communities & subcultures")
                    .font(.callout)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                  
                
                    ScrollView {
                        ForEach(vm.worlds.sorted(by: {$0.name < $1.name})) { world in
                            Button {
                                vm.addOrRemove(world: world)
                            } label: {
                                worldItem(world: world)
                            }
                        }
                    }
                    .frame(height: 400)
                
                
              
            }
            Spacer()
            
            Button(action: {
                vm.submitStreetPass()
            }, label: {
                HStack(spacing: 2) {
                    
                  Text("Create StreetPass")
                        .fontWeight(.light)
                        .foregroundStyle(.white)
                }
                .frame(width: 165, height: 50)
                .background(.blue)
                .clipShape(Capsule())
            })
            .padding(.top, 25)
        }
        .background(background())
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
    func background() -> some View {
        ZStack {
            Color.black
            Image("colored-paths")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
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
    
    

    
}

#Preview {
    ChooseWorldView(vm: UploadViewModel())
}
