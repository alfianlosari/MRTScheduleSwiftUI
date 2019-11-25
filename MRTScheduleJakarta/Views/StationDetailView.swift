//
//  StationDetailView.swift
//  MRTScheduleJakarta
//
//  Created by Alfian Losari on 11/24/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreLocation

struct StationDetailView: View {
    
    @State var isShowingMap = true
    
    let mrtSystem = MRTSystem()
    let station: Station
    let prevStation: Station?
    let nextStation: Station?
    
    init(station: Station) {
        self.station = station
        let (prev, next) = mrtSystem.connectingStations(for: station)
        self.prevStation = prev
        self.nextStation = next
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                self.isShowingMap.toggle()
            }) {
                HStack {
                    Text(self.isShowingMap ? "Hide Map" : "Show Map")
                    Spacer()
                    Image(systemName: "chevron.up.square")
                        .rotationEffect(.degrees(self.isShowingMap ? 0 : 180))
                        .animation(.default)
                }
                .padding(.horizontal)
            }
            
            if self.isShowingMap {
                MapView(coordinate: station.coordinate)
                    .frame(height: 240)
                    .animation(.default)
                    .transition(.opacity)
                    .onTapGesture {
                        let url = "http://maps.apple.com/maps?daddr=\(self.station.coordinate.latitude),\(self.station.coordinate.longitude)"
                        UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)
                        
                }
            }
            
            HStack {
                if prevStation != nil {
                    DepartureTimeListView(station: prevStation!)
                }
                Divider()
                
                if nextStation != nil {
                    DepartureTimeListView(station: nextStation!)
                }
            }
            
        }
        .navigationBarTitle(station.name)
    }
}



struct StationDetailView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        NavigationView {
            StationDetailView(station: MRTSystem().stations[1])
        }
        
    }
}

struct DepartureTimeListView: View {
    
    let station: Station
    var isPrev = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: StationDetailView(station: station)) {
                VStack {
                    Text(station.name)
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "tram.fill")
                        Text(isPrev ? station.prevDepartureTimeText : station.nextDepartureTimeText)
                            .font(.subheadline)
                    }
                }
            }
            
            
            List(isPrev ? station.prevTimes : station.nextTimes) { time in
                VStack(alignment: .leading) {
                    HStack {
                        Text(time.timeText)
                        if (time.holidayTimeText != nil) {
                            Divider()
                            Text(time.holidayTimeText!)
                                .foregroundColor(Color.red)
                        }
                    }
                    
                    if (time.note != nil) {
                        Text(time.note!)
                            .font(.caption)
                    }
                    
                }
                
            }
        }
    }
}
