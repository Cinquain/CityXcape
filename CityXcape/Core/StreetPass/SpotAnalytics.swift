//
//  SpotAnalytics.swift
//  CityXcape
//
//  Created by James Allan on 10/12/23.
//

import SwiftUI
import Charts
import PhotosUI
import SDWebImageSwiftUI

struct SpotAnalytics: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: StreetPassViewModel
    @State private var showDeleteAction: Bool = false

    let spot: Location
    
    
    @State var showPicker: Bool = false
    @State var spotImage: UIImage?
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    
    @State var data: [(name: String, value: Int)] = []
    @State var title: String = ""
    var body: some View {
        VStack {
            header()
            
            imageThumb()
            
            Picker("Metrics", selection: $vm.spotMetric) {
                ForEach(SpotMetric.allCases) { category in
                    Text(category.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .colorScheme(.dark)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            
            switch vm.spotMetric {
            case .Metrics:
                chart()
            case .Modify:
                editLocation()
            }
            
            Spacer()
        }
        .padding(.top, 10)
        .background(.black)
        .onAppear {
            createData()
        }
        
    }
    
    @ViewBuilder
    func header() -> some View {
        HStack {
            Image("Pin")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text(spot.name)
                .font(.title2)
                .foregroundColor(.white)
                .fontWeight(.thin)
                .alert(isPresented: $vm.showAlert) {
                    return Alert(title: Text(vm.alertMessage))
                }
            
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.square.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
    
    @ViewBuilder
    func imageThumb() -> some View {
        Button {
            vm.thumbcase = .one
            vm.showImagePicker.toggle()
        } label: {
            ZStack {
                if let image = vm.imageSelection {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(12)
                        .clipped()
                    
                } else {
                    WebImage(url: URL(string: vm.spotImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: .infinity)
                        .frame(maxHeight: 300)
                        .clipped()
                }
                ProgressView()
                    .opacity(vm.isUploading ? 1 : 0)
                    .scaleEffect(3)
            }
        }
        .sheet(isPresented: $showPicker, onDismiss: {
            vm.setSpotImage(from: spotImage)
        }) {
            ImagePicker(imageSelected: $spotImage, sourceType: $source)
                .colorScheme(.dark)
        }

           
    }
 
    @ViewBuilder
    func chart() -> some View {
        VStack {
            Text("Location Performance")
                .font(.caption)
                .fontWeight(.thin)
                .foregroundColor(.white)
            
            Chart(data, id: \.name) {
                BarMark(
                    x: .value("KPI", $0.name),
                    y: .value("Total", $0.value))
                .foregroundStyle(by: .value("Total", $0.name))
            }
            .frame(height: 300)
            .colorScheme(.dark)
        }
    }
    @ViewBuilder
    func editLocation() -> some View {
        
        Form {
            TextField("Change Title", text: $vm.editTitle)
      
            TextField("Add Description", text: $vm.editDetails)
                .sheet(isPresented: $vm.showImagePicker) {
                    switch vm.thumbcase {
                    case .one:
                        ImagePicker(imageSelected: $vm.imageSelection, sourceType: $vm.sourceType)
                    case .two:
                        ImagePicker(imageSelected: $vm.extraImage, sourceType: $vm.sourceType)
                    case .three:
                        ImagePicker(imageSelected: $vm.extraImageII, sourceType: $vm.sourceType)
                    }
                }
            
            extraImages()
            HStack {
                TextField("Enter longitude", text: $vm.longitude)
                   
                TextField("Enter latitude", text: $vm.latitude)
            }
            
            Section {
                finishButton()
            }
            
            Section {
                Button {
                    showDeleteAction.toggle()
                } label: {
                    HStack {
                        Image(systemName: "trash.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                        Text("Delete Location")
                            .foregroundColor(.red)
                            .fontWeight(.thin)
                            .actionSheet(isPresented: $showDeleteAction) {
                                return ActionSheet(title: Text("Are sure you want to delete"), buttons: [
                                    .destructive(Text("Yes"), action: {
                                        vm.deleteLocation(spotId: spot.id)
                                        if vm.isDeleted {
                                            dismiss()
                                            vm.isDeleted = false
                                        }
                                    }),
                                    .cancel(Text("Cancel"))
                                ])
                            }
                    }
                }
            }
            
            
            
        }
        .colorScheme(.dark)

    }
    
    fileprivate func createData() {
        let likes = (name: "Likes", value: Int(spot.likeCount))
        let saves = (name: "Saves", value: Int(spot.saveCount))
        let checkins = (name: "Checkins", value: Int(spot.checkinCount))
        let views = (name: "Views", value: Int(spot.viewCount))
        data.append(views)
        data.append(likes)
        data.append(saves)
        data.append(checkins)
    }
    
    @ViewBuilder
    func finishButton() -> some View {
        Button {
            vm.submitLocationChanges(spotId: spot.id)
        } label: {
            HStack(spacing: 2) {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                Text("Done")
                    .font(.headline)
                Spacer()
            }
            .foregroundColor(.cx_blue)
        }

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
                .opacity(vm.isUploading ? 1 : 0)
                .scaleEffect(3)
        }
    }
    
    
    @ViewBuilder
    func extraImages() -> some View {
        HStack {
            Button {
                vm.thumbcase = vm.extraImage == nil ? .two : .three
                vm.showImagePicker.toggle()
            } label: {
                Image(systemName: "plus.square.fill.on.square.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .scaledToFit()
                    .frame(width: 60)
            }
            
            Spacer()
            
                PickerLabel(pickerImage: vm.extraImage)
            
            Spacer()
       
                PickerLabel(pickerImage: vm.extraImageII)
            
           
        }
        .padding(.horizontal, 15)
    }
    
}

struct SpotAnalytics_Previews: PreviewProvider {
    static var previews: some View {
        SpotAnalytics(spot: Location.demo)
            .environmentObject(StreetPassViewModel())
    }
}
