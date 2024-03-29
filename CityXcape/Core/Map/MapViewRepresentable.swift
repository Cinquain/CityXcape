//
//  MapViewRepresentable.swift
//  CityXcape
//
//  Created by James Allan on 8/24/23.
//

import UIKit
import MapKit
import SwiftUI
import CoreLocation


struct MapViewRepresentable: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    let locationManager = LocationService.shared
    let mapView = MKMapView()
    var center: CLLocationCoordinate2D?
    
    @StateObject var viewModel: MapViewModel
    
    
    func makeUIView(context: Context) -> MKMapView {
        setRegionForMap()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.addPinFromTap(_:)))
        gesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(gesture)
        mapView.isUserInteractionEnabled = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //TBD
        //User searches location or drops pin
        if viewModel.annotations.count > 0 {
             uiView.removeAnnotations(uiView.annotations)
             viewModel.annotations.forEach { annotation in
                 uiView.addAnnotation(annotation)
             }
                   
             uiView.showAnnotations(uiView.annotations.filter({$0 is MKPointAnnotation}), animated: true)
         }
        
        //User selects a pin
        uiView.annotations.forEach { annotation in
            if annotation.title == viewModel.selectedMapItem?.name {
                uiView.selectAnnotation(annotation, animated: true)
            }
            
        }
}
    
    
    fileprivate func setRegionForMap() {
        guard let location = locationManager.userLocation else {
            locationManager.checkAuthorizationStatus()
            return}
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location,span: span)
        mapView.setRegion(region, animated: true)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.center = mapView.centerCoordinate
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
            if (annotation is MKPointAnnotation) {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "id")
                annotationView.canShowCallout = true
                let image = UIImage(named: "marker")
                annotationView.image = image
                return annotationView
            }
            return nil
        }
        
        
        @objc func addPinFromTap(_ gesture: UIGestureRecognizer) {
            print("Tag Gesture recognized!")
            
            let touchpoint = gesture.location(in: gesture.view)
            let coordinate = (gesture.view as? MKMapView)?.convert(touchpoint, toCoordinateFrom: gesture.view)
            
            guard let coordinate = coordinate else {return}
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            parent.viewModel.mapItems.append(mapItem)
            parent.viewModel.annotations.append(annotation)
        }
        
        
        
        
    }
    
}
