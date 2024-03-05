//
//  PostForm.swift
//  CityXcape
//
//  Created by James Allan on 8/30/23.
//

import SwiftUI
import MapKit
import PhotosUI

struct PostForm: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var vm: MapViewModel
    
    var body: some View {
        NavigationView {
            Form {
                TextField(vm.selectedMapItem?.name ?? "Location Name", text: $vm.spotName)
                TextField("Describe this location", text: $vm.spotDescription)
                    .frame(height: 40)
                    .alert(isPresented: $vm.showAlert) {
                        return Alert(title: Text(vm.alertMessage))
                    }
                
                
                Section("\(Image(systemName: "photo")) Location Image (Portrait)") {
                
                        Button {
                            vm.thumbcase = .one
                            vm.showActionSheet.toggle()
                        } label: {
                            PickerLabel(pickerImage: vm.selectedImage)
                        }
                        .sheet(isPresented: $vm.showPicker) {
                            switch vm.thumbcase {
                                case .one:
                                    ImagePicker(imageSelected: $vm.selectedImage, sourceType: $vm.sourceType)
                                        .colorScheme(.dark)
                                case .two:
                                    ImagePicker(imageSelected: $vm.extraImage, sourceType: $vm.sourceType)
                                        .colorScheme(.dark)
                                case .three:
                                    ImagePicker(imageSelected: $vm.extraImageII, sourceType: $vm.sourceType)
                                        .colorScheme(.dark)
                            }
                        }
                        
                }
                
                Section("Extra Images") {
                    extraImages()
                }
                
                
                
                Section("Address") {
                    locationView()
                        .actionSheet(isPresented: $vm.showActionSheet) {
                            ActionSheet(title: Text("Source Options"), buttons: [
                                .default(Text("Camera"), action: {
                                    vm.sourceType = .camera
                                    vm.showPicker.toggle()
                                }),
                                .destructive(Text("Photo Library"), action: {
                                    vm.sourceType = .photoLibrary
                                    vm.showPicker.toggle()
                                }),
                                .cancel()
                            ])
                        }
                }
                
                Section("Coordinates") {
                    HStack {
                        Text("Longitude: \(vm.longitude)")
                            .font(.caption)
                            .fontWeight(.thin)
                        Spacer()
                        Text("Latitude: \(vm.latitude)")
                            .font(.caption)
                            .fontWeight(.thin)
                          
                    }
                    .foregroundColor(.white)
                }
                
                Section("Finish") {
                    finishButton()
                }
            }
            .navigationBarTitle("Create Location", displayMode: .inline)
            .navigationBarItems(trailing: closeButton)


        }
        .colorScheme(.dark)

    }
    
    @ViewBuilder
    func finishButton() -> some View {
        Button(action: {
            vm.submitLocation()
        }, label: {
                
            HStack {
                Spacer()
                Image("Pin")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                Text("Create Spot")
                    .font(.headline)
                Spacer()
            }
            .foregroundColor(.cx_blue)
            .disabled(vm.isPosting)
        })

    }

    
    private var closeButton: some View {
        Button(action: {
                   dismiss()
               }, label: {
                   Image(systemName: "xmark.seal")
                       .resizable()
                       .scaledToFit()
                       .foregroundColor(.white)
                       .frame(height: 25)
               })
    }
    
    @ViewBuilder
    func locationView() -> some View {
        HStack {
                 Spacer()
                  Image(systemName: "location.fill")
                      .resizable()
                      .scaledToFit()
                      .frame(height: 20)
                  
            Text(vm.address)
                      .multilineTextAlignment(.center)
                      .lineLimit(1)
                 Spacer()
              }
              .foregroundColor(.white)
    }
    
    @ViewBuilder
    func PickerLabel(pickerImage: UIImage?) -> some View {
        ZStack {
            if let pickerImage {
                Image(uiImage: pickerImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .clipped()
            } else {
                    Image("spot_image")
                        .resizable()
                        .scaledToFill()
                        .frame(width: .infinity)
                
            }
            ProgressView()
                .opacity(vm.isPosting ? 1 : 0)
                .scaleEffect(3)
        }
    }
    
    @ViewBuilder
    func extraImages() -> some View {
        HStack {
            Button {
                vm.thumbcase = vm.extraImage == nil ? .two : .three
                vm.showActionSheet.toggle()
            } label: {
                Image(systemName: "plus.square.fill.on.square.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .scaledToFit()
                    .frame(width: 70)
            }
            
            Spacer()
            
                PickerLabel(pickerImage: vm.extraImage)
            
            Spacer()
       
                PickerLabel(pickerImage: vm.extraImageII)
            
           
        }
        .padding(.horizontal, 15)
    }
    
    
}

struct PostForm_Previews: PreviewProvider {
    static var previews: some View {
        PostForm(vm: MapViewModel())
            
    }
}
