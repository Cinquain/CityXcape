//
//  CreateStreetPass.swift
//  CityXcape
//
//  Created by James Allan on 2/24/24.
//

import SwiftUI
import PhotosUI

struct CreateStreetPass: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(AppUserDefaults.profileUrl) var profileUrl: String?

    @Binding var idCreated: Bool
    @State private var showPicker: Bool = false
    @State private var username: String = ""
    @State private var profileImage: UIImage?
    @StateObject var vm: UploadViewModel = UploadViewModel()
    
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    
    var body: some View {
        VStack {
            StreetPassHeader()
                .alert(isPresented: $showError) {
                    return Alert(title: Text(errorMessage))
                }
            
            
          
            
            PhotosPicker(selection: $vm.selectedImage, matching: .images, label: {
                VStack(spacing: 8) {
                    BubbleView(width: 300, imageUrl: vm.profileUrl ?? "", type: .personal)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.black)
                                .opacity(vm.profileUrl == "" ? 1 : 0)
                        }
                    
                    Text("Tap to Upload Image")
                        .foregroundColor(.white)
                        .fontWeight(.thin)
                }
            })
            
            
            TextField("Enter a Username", text: $username)
                .frame(width: 250, height: 40)
                .background(.white)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .clipShape(Capsule())
                .padding(.top, 30)
                
            
            Button {
                submitData()
            } label: {
                Text("Create StreetPass")
                    .foregroundColor(.white)
                    .fontWeight(.thin)
                    .frame(width: 220, height: 40)
                    .background(.cyan)
                    .clipShape(Capsule())
            }
            .padding(.top, 50)
            
            if idCreated {
                DismissButton()
            }

            
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
    func DismissButton() -> some View {
        Button {
            dismiss()
        } label: {
            Text("DISMISS")
                .font(.caption)
                .fontWeight(.light)
                .foregroundColor(.black)
                .background(Capsule().fill(.gray.opacity(0.8)).frame(width: 120, height: 40))
                .padding(.top, 75)
        }
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
                 
                
                Text("STC Balance: 0")
                    .font(.caption)
                    .fontWeight(.thin)
                    .opacity(0.7)
                  
                
            }
            .foregroundColor(.white)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.title)
            }

        }
        .padding(.horizontal, 10)
    }
    
   
    
    fileprivate func submitData() {
        if vm.profileUrl == "" {
            errorMessage = "Please upload a personal image for your StreetPass"
            showError.toggle()
            return
        }
        if username.count < 3 {
            errorMessage = "Please create a username of at least 3 characters"
            showError.toggle()
            return 
        }
        let data: [String: Any] = [
            User.CodingKeys.username.rawValue: username
        ]
        Task {
            do {
                try await DataService.shared.updateStreetPass(data: data)
                UserDefaults.standard.set(username, forKey: AppUserDefaults.username)
                UserDefaults.standard.set(true, forKey: AppUserDefaults.createdSP)
                idCreated = true
                errorMessage = "Successfully Created StreetPass!"
                showError.toggle()
            } catch {
                errorMessage = error.localizedDescription
                showError.toggle()
            }
        }
    }
    
}

struct CreateStreetPass_Previews: PreviewProvider {
    @State static var id: Bool = false
    static var previews: some View {
        CreateStreetPass(idCreated: $id)
    }
}
