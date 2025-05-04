//
//  StreetPass.swift
//  CityXcape
//
//  Created by James Allan on 8/2/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct StreetPass: View {

    @StateObject var vm = StreetPassViewModel()
    @State private var showAuth: Bool = false
    
    var body: some View {
        VStack {
            header()
            userView()
            worldList()
            passport()
            showStats()
            Spacer()
            if vm.user == nil {
                getSPButton()
            }
        }
        .background(SPBackground())
        .onAppear {
            vm.getUser()
        }
    }
    
    

    
    @ViewBuilder
    func header() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vm.user?.city ?? "")
                    .font(.caption)
                    .fontWeight(.thin)
                    .foregroundStyle(.white)
                    .tracking(4)
                    .alert(isPresented: $vm.showError, content: {
                        return Alert(title: Text(vm.errorMessage))
                    })
                
                Text(CXStrings.streetpass)
                    .font(.system(size: 24))
                    .fontWeight(.thin)
                    .tracking(4)
                    .opacity(0.7)
                    .photosPicker(isPresented: $vm.showPicker, selection: $vm.selectedImage, matching: .images)
                
                
            }
            .foregroundStyle(.white)
            .fullScreenCover(isPresented: $vm.showOnboarding, onDismiss: {
                vm.getUser()
            }, content: {
                Onboarding()
            })
            
            Spacer()
            
            Menu{
                
                Button {
                    vm.openCustomUrl(link: CXStrings.privacyLink)
                                } label: {
                                    Label(CXStrings.privacy, systemImage: "hand.raised.circle.fill")
                                }
                                
                Button {
                    vm.openCustomUrl(link: CXStrings.termsLink)
                } label: {
                    Label(CXStrings.terms, systemImage: "doc.text.magnifyingglass")
                }

                
                Button(action: vm.signout) {
                Label("Signout", systemImage: "power.circle.fill")
                                 }
                
                Button(action: vm.deleteAccount) {
                                       Label("Delete Account", systemImage: "person.crop.circle.fill.badge.minus")
                                   }
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func worldList() -> some View {
        HStack {
            ForEach(vm.user?.worlds ?? []) { world in
                Button {
                    AnalyticService.shared.viewedWorld()
                    vm.errorMessage = "You're part of the \(world.name) world"
                    vm.showError.toggle()
                } label: {
                    VStack {
                        WebImage(url: URL(string: world.imageUrl))
                            .resizable()
                            .scaledToFit()
                            .colorInvert()
                        .frame(height: 65)
              
                    }
                }

            }
        }
        .padding(.top, 10)
        
    }
    
    @ViewBuilder
    func userView() -> some View {
        VStack {
            
            Button(action: {
                vm.showPicker.toggle()
            }, label: {
                    SelfieBubble(
                        size: 320,
                        url: vm.user?.imageUrl ?? "https://firebasestorage.googleapis.com/v0/b/cityxcape-70313.appspot.com/o/Users%2FJohn%20Doe%2FJane%20Doe.png?alt=media&token=475bdf1b-21f3-4335-afb5-50c4a4170632",
                    pulse: 1.2)
            })
            
            
            VStack {
                Text(vm.user?.username ?? "")
                    .font(.title)
                .fontWeight(.thin)
                
                Text("\(vm.user?.streetcred ?? 0) StreetCred")
                    .fontWeight(.thin)
                    .font(.callout)

            }
            .foregroundStyle(.white)

            
          
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    func passport() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                vm.getStamps()
            }, label: {
                HStack {
                    Image(systemName: "menucard.fill")
                        .font(.title)
                    
                    Text("Passport")
                        .font(.title)
                        .fontWeight(.thin)
                    
                }
                .foregroundStyle(.white)
            })
            .sheet(isPresented: $vm.showPassport, content: {
                PassportPage(stamps: vm.stamps)
            })
            
           
        }
        .padding(.top, 20)
        .opacity(vm.user != nil ? 1 : 0)

    }
    
    @ViewBuilder
    func showStats() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                vm.fetchAnalytics()
            }, label: {
                HStack {
                    Image(systemName: "chart.xyaxis.line")
                        .font(.title2)
                    
                    Text("Analytics")
                        .font(.title)
                        .fontWeight(.thin)
                    
                }
                .foregroundStyle(.white)
            })
            .fullScreenCover(isPresented: $vm.showStats) {
                StreetReportCard(vm: vm)
            }
           
            
           
        }
        .padding(.top, 5)
        .opacity(vm.user != nil ? 1 : 0)

    }
    
   
    
    func openCustom(url: String) {
        guard let url = URL(string: url) else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @ViewBuilder
    func getSPButton() -> some View {
        Button {
            vm.showOnboarding.toggle()
        } label: {
            Text("Get StreetPass")
                .fontWeight(.thin)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 200, height: 40)
                .background(.blue)
                .clipShape(Capsule())
                .fullScreenCover(isPresented: $vm.showOnboarding) {
                    Onboarding()
                }
        }
        .padding(.bottom, 10)

    }
    
}

#Preview {
    StreetPass(vm: StreetPassViewModel())
}
