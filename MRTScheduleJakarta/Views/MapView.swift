//
//  MapView.swift
//  MRTScheduleJakarta
//
//  Created by Alfian Losari on 11/25/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
 
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        return MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        let adustedRegion = uiView.regionThatFits(region)
        uiView.setRegion(adustedRegion, animated: true)
        uiView.showsUserLocation = true
    }
    
}
