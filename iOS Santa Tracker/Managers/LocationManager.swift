//
//  LocationManager.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 12/10/2022.
//

import Foundation
import MapKit
import Throttler

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: CLLocation?)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}

enum MapType {
    case explore
    case driving
    case transport
    case satellite
}

class LocationManager: NSObject, ObservableObject {
    
    @Published var currentRegion: MKCoordinateRegion = MKCoordinateRegion()
    @Published var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @Published var displayedRegionTracking: Bool = false
    
    @Published var locationUpdatesEnabled: Bool = true
    @Published var locationStatus: CLAuthorizationStatus = .notDetermined
    
    @Published var displayedRegionLockedRoute: Bool = false
    
    @Published var mapType: MapType = .explore
    
    private var locationManagerDelegate: LocationManagerDelegate?
    private var realtimeFirestore = RealtimeFirestore()
        
    var locationManager = CLLocationManager()
    static var shared: LocationManager = LocationManager()
    
    override init() {
        
        super.init()
        
        locationStatus = locationManager.authorizationStatus
        
        locationManager.delegate = self
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .automotiveNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (locationManager.authorizationStatus == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }
    }
    
    static func handleEnterForeground() {
        LocationManager.shared = LocationManager()
        LocationManager.shared.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.shared.locationManager.startUpdatingLocation()
    }
    
    static func handleEnterBackground() {
        LocationManager.shared = LocationManager()
        LocationManager.shared.locationManager.stopUpdatingLocation()
        LocationManager.shared.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    static func handleAppKilled() {
        LocationManager.shared = LocationManager()
        LocationManager.shared.locationManager.stopUpdatingLocation()
        LocationManager.shared.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func requestLocation() {
        if (locationManager.authorizationStatus == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        locationStatus = status
        
        if (status == .authorizedWhenInUse) {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        if status == .denied || status == .notDetermined || status == .authorizedWhenInUse || status == .restricted {
            return
        }
        
        manager.startUpdatingLocation()
        
        locationManagerDelegate?.locationManager(manager, didChangeAuthorization: status)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManagerDelegate?.didUpdateLocation(locations.first)
        
        let currentLocationCoordinates = CLLocationCoordinate2D(latitude: locations.first?.coordinate.latitude ?? 0, longitude: locations.first?.coordinate.longitude ?? 0)
        let currentLocationSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        
        let currentRegion = MKCoordinateRegion(center: currentLocationCoordinates, span: currentLocationSpan)
        
        self.currentLocation = currentLocationCoordinates
        self.currentRegion = currentRegion
        
        if (locationUpdatesEnabled) {
            Throttler.throttle(identifier: "location", delay: 5, shouldRunImmediately: true) {
                self.realtimeFirestore.updateLocation(currentLocationCoordinates)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //        print("LocationManager fail with error \(error.localizedDescription)")
    }
}
