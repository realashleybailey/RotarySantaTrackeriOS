//
//  MapView.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 10/11/2022.
//

import SwiftUI
import MapKit
import CoreLocation
import Pulsator

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var routeManager: RouteManager
    
    @State var currentLocationAnnotation: MKPointAnnotation = MKPointAnnotation()
    @State var currentLocationPulsator: Pulsator = Pulsator()
    
    // Create the MapKit view
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        
        mapView.delegate = context.coordinator
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "usersCurrentLocation")
        mapView.showsUserLocation = false
        
        currentLocationAnnotation.coordinate = locationManager.currentLocation
        mapView.addAnnotation(currentLocationAnnotation)
        
        currentLocationPulsator.start()
                
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {

        view.translatesAutoresizingMaskIntoConstraints = false
                
        if (locationManager.displayedRegionTracking) {
            UIView.animate(withDuration: 1) {
                view.setRegion(locationManager.currentRegion, animated: true)
            }
        }
        
        if (locationManager.displayedRegionLockedRoute) {
            UIView.animate(withDuration: 1) {
                regionToRoute(routeManager.currentRoute, view)
            }
        }
        
        updateCurrentLocationAnnotation(currentLocation: locationManager.currentLocation, mapView: view)
        
        addRouteToMap(routeManager.currentRoute, view)

        switch locationManager.mapType {
        case .explore:
            view.mapType = .standard
            view.showsTraffic = false
        case .driving:
            view.mapType = .standard
            view.showsTraffic = true
        case .transport:
            view.mapType = .standard
            view.showsTraffic = false
        case .satellite:
            view.mapType = .satellite
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func compareRegions(_ old: MKCoordinateRegion, _ current: MKCoordinateRegion) -> Bool {
        if (old.center.latitude != current.center.latitude || old.center.longitude != current.center.longitude || old.span.latitudeDelta != current.span.latitudeDelta || old.span.longitudeDelta != current.span.longitudeDelta) {
            return true
        }
        
        return false
    }
    
    func addRouteToMap(_ route: KMLDocument?, _ mapView: MKMapView) {
        if !mapView.overlays.isEmpty {
            mapView.removeOverlays(mapView.overlays)
        }
        
        guard let KMLDocument = route else {
            return
        }
        
        mapView.addOverlays(KMLDocument.overlays, level: .aboveRoads)
    }
    
    func regionToRoute(_ route: KMLDocument?, _ mapView: MKMapView) {
        guard let KMLDocument = route else {
            return
        }
        
        guard let overlay = KMLDocument.overlays.first else {
            return
        }
        
        mapView.setVisibleMapRect(overlay.boundingMapRect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
    }
    
    func updateCurrentLocationAnnotation(currentLocation: CLLocationCoordinate2D, mapView: MKMapView) {
        UIView.animate(withDuration: 2) {
            currentLocationAnnotation.coordinate = currentLocation
        }
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            // Create Renderer
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            // Change Color of KML lines
            renderer.fillColor = UIColor.primary.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.primary.withAlphaComponent(0.8)
            
            // Change Width of KML Lines
            renderer.lineWidth = 3
            
            // Return the Renderer
            return renderer
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "usersCurrentLocation", for: annotation) as? MKMarkerAnnotationView {
                
                parent.currentLocationPulsator.numPulse = 2
                parent.currentLocationPulsator.radius = 30
                parent.currentLocationPulsator.animationDuration = 1.5
                parent.currentLocationPulsator.backgroundColor = UIColor(.primary).cgColor
                
                parent.currentLocationPulsator.position = CGPoint(x: 14, y: 9)
                
                annotationView.layer.addSublayer(parent.currentLocationPulsator)
                annotationView.glyphImage = UIImage(systemName: "person")
                annotationView.markerTintColor = .primary
                                
                return annotationView
            }

            return nil
        }
    }
    
}
