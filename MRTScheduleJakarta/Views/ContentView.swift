//
//  ContentView.swift
//  MRTScheduleJakarta
//
//  Created by Alfian Losari on 11/24/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let mrtSystem = MRTSystem()
    @ObservedObject var locationManager = LocationManagerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if locationManager.nearestStation != nil {
                    NavigationLink(destination: StationDetailView(station: locationManager.nearestStation!)) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                HStack {
                                    Image(systemName: "location.fill")
                                    Text("Nearest Station")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text(locationManager.nearestStation!.name)
                            }
                            
                            if locationManager.prevStation != nil {
                                HStack {
                                    HStack {
                                        Image(systemName: "tram.fill")
                                        Text(locationManager.prevStation!.name)
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Text(locationManager.nearestStation!.prevDepartureTimeText)
                                }
                                
                            }
                            if locationManager.nextStation != nil {
                                HStack {
                                    HStack {
                                        Image(systemName: "tram.fill")
                                        Text(locationManager.nextStation!.name)
                                            .font(.subheadline)
                                    }
                                    Spacer()
                                    Text(locationManager.nearestStation!.nextDepartureTimeText)
                                }
                            }
                        }
                        .padding(.all)
                    }
                }
                
                List(self.mrtSystem.stations) { station in
                    NavigationLink(destination: StationDetailView(station: station)) {
                        Text(station.name)
                    }
                }
            }
            .navigationBarTitle("MRT Jakarta")
        }.onAppear {
            self.locationManager.start()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
