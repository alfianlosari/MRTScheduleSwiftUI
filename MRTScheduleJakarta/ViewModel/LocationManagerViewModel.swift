//
//  LocationManagerViewModel.swift
//  MRTScheduleJakarta
//
//  Created by Alfian Losari on 11/25/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Combine
import CoreLocation
import SwiftUI

class LocationManagerViewModel: NSObject, ObservableObject {
    
    var locationManager: CLLocationManager!
    let mrtSystem = MRTSystem()
    var prevStation: Station?
    var nextStation: Station?
      
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var nearestStation: Station?
    var currentLocation: CLLocationCoordinate2D? {
        didSet {
            guard let coordinate = self.currentLocation else { return }
            let nearestStation = mrtSystem.findClosestStation(currentCoordinate: coordinate)
            defer {
                 self.nearestStation = nearestStation
            }
            guard let _nearestStation = nearestStation else {
                self.prevStation = nil
                self.nextStation = nil
                return
            }
            let (prev, next) = mrtSystem.connectingStations(for: _nearestStation)
            self.prevStation = prev
            self.nextStation = next
        }
    }
    
    func start() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        
        authorizationStatus = CLLocationManager.authorizationStatus()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

}

extension LocationManagerViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        locationManager.startUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
    
}
