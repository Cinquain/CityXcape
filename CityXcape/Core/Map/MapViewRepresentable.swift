//
//  MapViewRepresentable.swift
//  CityXcape
//
//  Created by James Allan on 9/27/24.
//

import UIKit
import MapKit
import SwiftUI
import CoreLocation

struct MapViewRepresentable: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    let manager = LocationService.shared
    let mapView = MKMapView()
    var center: CLLocationCoordinate2D?
    
    
    func makeUIView(context: Context) -> MKMapView {
        setRegionForMap()
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = false
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if manager.annotations.count > 0 {
            uiView.removeAnnotations(uiView.annotations)
            manager.annotations.forEach { annotation in
                uiView.addAnnotation(annotation)
            }
            uiView.showAnnotations(uiView.annotations.filter({$0 is MKPointAnnotation}), animated: true)
        }
    }
    
    
    fileprivate func setRegionForMap() {
        guard let location = manager.userCoordinates else {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(parent: MapViewRepresentable) {
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
            let touchpoint = gesture.location(in: gesture.view)
            let coordinate = (gesture.view as? MKMapView)?.convert(touchpoint, toCoordinateFrom: gesture.view)
            guard let coordinate = coordinate else {return}
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            parent.manager.annotations.append(annotation)
        }
        
    }
    
}
