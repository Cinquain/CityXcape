//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/29/23.
//

import SwiftUI
import PhotosUI

struct StreetPass: View {
    
    @AppStorage(AppUserDefaults.username) var username: String?
    @AppStorage(AppUserDefaults.profileUrl) var profileUrl: String?
    @AppStorage(AppUserDefaults.streetcred) var streetcred: Int?

    @EnvironmentObject private var vm: StreetPassViewModel

    var body: some View {
        
            VStack {
                StreetPassHeader()
                UserDot()
                usernameField()
                Spacer()
                    .frame(height: 70)
                MyJourney()
               
                
                Spacer()
            }
            .background(Background())
        
    }
    
    
    @ViewBuilder
    func Background() -> some View {
        ZStack {
            Color.black
            Image("street-paths")
                .resizable()
                .scaledToFill()
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    func StreetPassHeader() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("STREETPASS")
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .tracking(4)
                    .opacity(0.7)
                    .alert(isPresented: $vm.showAlert) {
                        Alert(title: Text(vm.alertMessage), primaryButton: .default(Text("Ok")) {
                            vm.showSignUp.toggle()
                        }, secondaryButton: .cancel())
                    }
                
                Text("STC Balance: \(streetcred ?? 0)")
                    .font(.caption)
                    .fontWeight(.thin)
                    .opacity(0.7)
                    .sheet(isPresented: $vm.editSP) {
                        EditProfile(vm: vm)
                    }

            }
            .foregroundColor(.white)

            Spacer()
            Menu {
                
                Button(action: vm.showSignup) {
                       Label("Login/Signup", systemImage: "person.crop.circle.fill.badge.checkmark")
                   }
                
                Button(action: vm.editStreetPass) {
                       Label("Edit StreetPass", systemImage: "pencil.circle")
                   }
                
                Button {
                    openCustomUrl(link: "https://www.cityxcape.com/privacy_policy")
                } label: {
                    Label("Privacy Policy", systemImage: "hand.raised.circle.fill")
                }
                
                Button {
                    openCustomUrl(link: "https://www.cityxcape.com/terms")
                } label: {
                    Label("Terms & Conditions", systemImage: "doc.text.magnifyingglass")
                }
                
                //Sign out user
                Button(action: vm.signOut) {
                       Label("Signout", systemImage: "point.filled.topleft.down.curvedto.point.bottomright.up")
                   }
                
                
                
                Button(action: vm.deleteAccount) {
                       Label("Delete Account", systemImage: "person.crop.circle.fill.badge.minus")
                   }
             
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.5))
                }
            
       


        }
        .padding(.horizontal, 25)
    }
    
    @ViewBuilder
    func UserDot() -> some View {
        
        Button {
            vm.showPicker.toggle()
        } label: {
            VStack(spacing: 3) {
                BubbleView(width: 300, imageUrl: profileUrl ?? "", type: .personal)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.black)
                            .opacity(profileUrl == nil ? 1 : 0)
                    }
                  
            }
            .padding(.top, 20)
        }
        .sheet(isPresented: $vm.showPicker) {
            ImagePicker(imageSelected: $vm.selectedItem, sourceType: $vm.sourceType)
                .colorScheme(.dark)
        }
    }
    
    @ViewBuilder
    func usernameField() -> some View {
      
        Text(username ?? "Create a Username")
            .font(.title3)
            .foregroundColor(.white)
            .fontWeight(.thin)
            .onTapGesture {
                if username == nil {
                    vm.editSP.toggle()
                }
            }
            
    }
    
    
    @ViewBuilder
    func MyJourney() -> some View {
  
        VStack(alignment: .leading, spacing: 20) {
            
            Button {
                vm.fetchStamps()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "book.circle")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Passport")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.thin)

                }
                .fullScreenCover(isPresented: $vm.showDiary) {
                    TravelDiary(stamps: vm.stamps)
                }
                
            }
            
            Button {
                vm.fetchBucketList()
            } label: {
                HStack(spacing: 10) {
                    
                    Image(systemName: "bookmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("Bucket List")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                        .popover(isPresented: $vm.showBucketList) {
                            BucketList(locations: vm.bucketList)
                                .presentationDetents([.medium])
                        }
                        .presentationDetents([.medium])

                }

            }
     
            
            Button {
                vm.fetchUploads()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    
                    Text("Analytics")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                }

            }
            .fullScreenCover(isPresented: $vm.showStreetRep) {
                StreetReportCard(vm: vm)
            }
            
          

            
        }
        
    }
    

    func openCustomUrl(link: String) {
        guard let url = URL(string: link) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}

struct StreetPass_Previews: PreviewProvider {
    static var previews: some View {
        StreetPass()
            .environmentObject(StreetPassViewModel())
    }
}
