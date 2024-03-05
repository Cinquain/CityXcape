//
//  SecretSpotView.swift
//  CityXcape
//
//  Created by James Allan on 8/15/23.
//

import SwiftUI
import AsyncButton
import SDWebImageSwiftUI

struct LocationView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    @Environment(\.dismiss) private var dismiss


    let spot: Location
    
    var body: some View {
        
            ZStack {
                   MainImage()
                 
                    if vm.showStamp {
                        StampView(spot: spot)
                            .padding(.bottom, 20)
                          
                    }
                    
                    ZStack {
                        BlurView(style: .systemMaterialDark)
                        DrawerView()
                            .animation(.easeIn(duration: 0.3), value: vm.showCheckinList)
                    }
                    .cornerRadius(12)
                    .offset(y: vm.offset)
                   
                   
                
                        

                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            let startLocation = value.startLocation
                            vm.offset = startLocation.y + value.translation.height
                        })
                )
                .onAppear {
                    vm.extraImages.insert(spot.imageUrl, at: 0)
                    vm.extraImages.append(contentsOf: spot.extraImages)
                    vm.updateViewCount(spot: spot)
                }
                .onDisappear {
                    vm.showStamp = false
                    vm.extraImages = []
                    vm.showExtraImage = false
                }
        
        
    }
    
  
    
    @ViewBuilder
    func MainImage() -> some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                Color.black
                WebImage(url: URL(string: vm.showExtraImage ? vm.extraImages[vm.currentIndex]
                                        : spot.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .overlay {
                     CustomLayer(size: size)
                    }
                    .sheet(isPresented: $vm.showBucketList) {
                        BucketList(locations: vm.saves)
                            .presentationDetents([.height(350)])
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func DrawerView() -> some View {
        VStack {
            Capsule()
                .frame(width: 100, height: 7)
                .foregroundColor(.white)
                .padding(.top, 7)
            
                ButtonRow()
                buttonRow2()

               
                CheckInButton()
            
            if vm.option == .showInfo {
                VStack(alignment: .leading, spacing: 10) {
                    Text(spot.description)
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .opacity(vm.opacity)
                        .multilineTextAlignment(.leading)
                        .animation(.easeIn(duration: 0.5), value: vm.opacity)
                    
                    Text("Address: \(spot.address ?? "")")
                        .font(.callout)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                        .opacity(vm.opacity)
                        .animation(.easeIn(duration: 0.5), value: vm.opacity)
                       
                    ownerDetails()

                }
                .padding(20)
            }
            
            

            
            Spacer()
        }

    }
    
    @ViewBuilder func TitleView() -> some View {
        HStack {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            Text(spot.name)
                .font(.system(size: 32))
                .foregroundColor(.white)
                .fontWeight(.thin)
                .lineLimit(1)
            
            Spacer()
            
            Button {
                 dismiss()
               } label: {
                   Image(systemName: "arrow.uturn.down.circle.fill")
                       .font(.title)
                       .foregroundColor(.white)
               }
      

        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func CustomLayer(size: CGSize) -> some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(.linearGradient(colors: [
                    .black.opacity(0.1),
                    .black.opacity(0.2),
                    .black], startPoint: .bottom, endPoint: .top))
                .frame(height: size.height)
            TitleView()
                .padding(.top, size.height / 18)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func ownerDetails() -> some View {
        HStack {
               
            VStack(alignment: .leading, spacing: 2) {
                UserDot(width: 50, imageUrl: spot.ownerImageUrl)
                Text("Posted by")
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .font(.caption)
            }
           
            
            Spacer()

            VStack {
                Image(systemName: "eye.fill")
                    .font(.title2)
                Text("\(spot.viewCount) wiews")
                    .font(.callout)
                .fontWeight(.thin)
            }
            .foregroundColor(.white)

           
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func ButtonRow() -> some View {
        HStack(alignment: .center) {
            
            Button {
                withAnimation(.easeIn(duration: 0.5)) {
                    vm.seeMoreInfo()
                }
            } label: {
                Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundColor(vm.option == .showInfo ? .purple : .white)
                    .particleEffect(
                        systemName: "plus.circle.fill",
                        font: .title2,
                        status: vm.option == .showInfo,
                        activeTint: .purple,
                        inactiveTint: .blue)
                    .frame(width: 55, height: 55)
                    .background(vm.option == .showInfo ? .purple.opacity(0.25) : .blue)
                    .clipShape(Circle())
                    .scaleEffect(vm.option == .showInfo ? 0.9 : 1)

            }
            .alert(isPresented: $vm.showAlert) {
                vm.normalAlert ? Alert(title: Text(vm.alertMessage), dismissButton: .cancel(Text("OK"), action: {vm.normalAlert = false})) :
                Alert(title: Text(vm.alertMessage), primaryButton: .default(Text("Ok")) {
                    vm.showSignUp.toggle()
                }, secondaryButton: .cancel {
                    withAnimation {
                        vm.option = .none
                    }
                })
            }
            
         
            
            Button {
                vm.likeLocation(spot: spot)
            } label: {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(vm.option == .like ? .red : .white)
                    .particleEffect(
                        systemName: "person.2.fill",
                        font: .title2,
                        status: vm.option == .like,
                        activeTint: .red,
                        inactiveTint: .pink)
                    .frame(width: 55, height: 55)
                    .background(vm.option == .like ? .red.opacity(0.25) : .pink.opacity(0.75))
                    .clipShape(Circle())
                    .scaleEffect(vm.option == .like ? 0.9 : 1)

            }
            
            Button {
                vm.saveToBookmark(spot: spot)
            } label: {
                Image(systemName: "bookmark.fill")
                    .font(.title2)
                    .foregroundColor(vm.option == .bookmark ? .orange : .white)
                    .particleEffect(
                        systemName: "checkmark.seal.fill",
                        font: .title2,
                        status: vm.option == .bookmark,
                        activeTint: .orange,
                        inactiveTint: .yellow)
                    .frame(width: 55, height: 55)
                    .background(vm.option == .bookmark ? .orange.opacity(0.25) : .yellow.opacity(0.8))
                    .clipShape(Circle())
                    .scaleEffect(vm.option == .bookmark ? 0.9 : 1)

            }
            
        }
        .padding(.top, 5)
    }
    
    
    @ViewBuilder
    func buttonRow2() -> some View {
        HStack {
            Button {
                vm.showDirections(spot: spot)
            } label: {
                Image(systemName: "car.fill")
                    .font(.title2)
                    .foregroundColor(vm.option == .showMap ? .white : .white)
                    .particleEffect(
                        systemName: "car.fill",
                        font: .title2,
                        status: vm.option == .showMap,
                        activeTint: .white,
                        inactiveTint: .gray)
                    .frame(width: 55, height: 55)
                    .background(vm.option == .showMap ? .cyan.opacity(0.25) : .green.opacity(1))
                    .clipShape(Circle())
                    .scaleEffect(vm.option == .showMap ? 0.9 : 1)

            }
            
            Button {
                vm.showImages()
            } label: {
                Image(systemName: "photo.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .particleEffect(
                        systemName: "xmark",
                        font: .title2,
                        status: vm.option == .gallery,
                        activeTint: .white,
                        inactiveTint: .gray)
                    .frame(width: 55, height: 55)
                    .background(.purple.opacity(1))
                    .clipShape(Circle())

            }
            
            Button {
               vm.option = .none
               dismiss()
            } label: {
                Image(systemName: "arrow.uturn.down.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .particleEffect(
                        systemName: "arrow.uturn.down.circle.fill",
                        font: .title2,
                        status: false,
                        activeTint: .white,
                        inactiveTint: .gray)
                    .frame(width: 55, height: 55)
                    .background(.black)
                    .clipShape(Circle())

            }
            
        }
    }
    
    @ViewBuilder
    func CheckInButton() -> some View {
        Button {
            vm.checkinLocation(spot: spot)
        } label: {
            Text("CHECK IN")
                .font(.subheadline)
                .fontWeight(.thin)
                .foregroundColor(.white)
                .background(Capsule()
                    .fill(.black)
                    .frame(width: 150, height: 40))
                .padding(.top, 25)
        }
    }
    
}

struct SecretSpotView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(spot: Location(data: Location.data))
            .environmentObject(LocationsViewModel())
    }
}
