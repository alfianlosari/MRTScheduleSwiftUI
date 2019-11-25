//
//  MRTSystem.swift
//  MRTScheduleJakarta
//
//  Created by Alfian Losari on 11/24/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import CoreLocation

struct MRTSystem {
    
    let linkedList: LinkedList<Station>
    
    var stations: [Station] {
        var current = linkedList.node
        var stations = [current.item]
        while current.nextNode != nil {
            current = current.nextNode!
            stations.append(current.item)

        }
        return stations
    }
    
    init() {
        // TODO: Initialize with real schedule times
        
        let bundaranHI = Station(name: "Bundaran HI", coordinate: CLLocationCoordinate2D(latitude: -6.1919, longitude: 106.8230))
        let linkedList = LinkedList(node: Node(item: bundaranHI))
        
        let stations = [
            Station(name: "Setiabudi Astra", coordinate: CLLocationCoordinate2D(latitude: -6.2091, longitude: 106.8217)),
            Station(name: "Dukuh Atas BNI", coordinate: CLLocationCoordinate2D(latitude: -6.2008, longitude: 106.8228)),
            Station(name: "Bendungan Hilir", coordinate: CLLocationCoordinate2D(latitude: -6.2150, longitude: 106.8179)),
            Station(name: "Istora Mandiri", coordinate: CLLocationCoordinate2D(latitude: -6.2224, longitude: 106.8086)),
            Station(name: "Senayan", coordinate: CLLocationCoordinate2D(latitude: -6.2267, longitude: 106.8025)),
            Station(name: "Asean", coordinate: CLLocationCoordinate2D(latitude: -6.2388, longitude: 106.7984)),
            Station(name: "Blok M", coordinate: CLLocationCoordinate2D(latitude: -6.2444, longitude: 106.7981)),
            Station(name: "Blok A", coordinate: CLLocationCoordinate2D(latitude: -6.2558, longitude: 106.7971)),
            Station(name: "Haji Nawi", coordinate: CLLocationCoordinate2D(latitude: -6.2667, longitude: 106.7973)),
            Station(name: "Cipete Raya", coordinate: CLLocationCoordinate2D(latitude: -6.2784, longitude: 106.7973)),
            Station(name: "Fatmawati", coordinate: CLLocationCoordinate2D(latitude: -6.2926, longitude: 106.7939)),
            Station(name: "Lebak Bulus Grab", coordinate: CLLocationCoordinate2D(latitude: -6.2893, longitude: 106.7749))
        ]
        stations.forEach { linkedList.add(Node(item: $0)) }
        self.linkedList = linkedList
    }
    
    func connectingStations(for station: Station) -> (previous: Station?, next: Station?) {
        guard let theStation = linkedList.node(for: station) else { return (nil, nil) }
        return (theStation.prevNode?.item, theStation.nextNode?.item)
    }
    
    func findClosestStation(currentCoordinate: CLLocationCoordinate2D) -> Station? {
        let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.longitude)
        var closestStation: Station?
        var smallestDistance: CLLocationDistance?
        for station in self.stations {
            let location = CLLocation(latitude: station.coordinate.latitude, longitude: station.coordinate.longitude)
            let distance = currentLocation.distance(from: location)
            if smallestDistance == nil || distance < smallestDistance! {
                closestStation = station
                smallestDistance = distance
            }
        }
        return closestStation
    }
}

struct DepartTime: Identifiable {
    
    var id: String {
        return "\(hour)\(minute)\(holidayMinute ?? 0)\(note ?? "")"
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var hour: Int
    var minute: Int
    var holidayMinute: Int?
    var note: String?
    
    var dateComponent: DateComponents {
        DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: 25200)!, year: 2001, month: 1, day: 1, hour: hour, minute: minute, second: 0)

    }
    
    var holidayDateComponent: DateComponents? {
        guard let hMinute = holidayMinute else { return nil }
        return DateComponents(calendar: .current, timeZone: TimeZone(secondsFromGMT: 25200)!, year: 2001, month: 1, day: 1, hour: hour, minute: hMinute, second: 0)
    }
    
    
    var holidayTimeText: String? {
        guard let date = holidayDateComponent?.date else { return nil }
        return DepartTime.dateFormatter.string(from: date)
    }
    
    var timeText: String {
        guard let date = dateComponent.date else { return "" }
        return DepartTime.dateFormatter.string(from: date)
    }
    
    static var randomTimes: [DepartTime] {
        let minutes = (0...59).map { $0 }
        return (5...23).map { (hour) -> [DepartTime] in
            let departTimes =  (0...3).map { time -> DepartTime in
                return DepartTime(hour: hour, minute: minutes.randomElement() ?? 0, holidayMinute: hour > 10 && hour < 17 ? minutes.randomElement() ?? nil : nil, note: hour > 21 ? "next station only" : nil)
            }
            return departTimes
        }.flatMap { $0 }
    }
}

struct Station: Identifiable {
    
    var id: String { name }
    var name: String
    var coordinate: CLLocationCoordinate2D
    
    // TODO: Replace this with real data
    
    var prevTimes: [DepartTime] = DepartTime.randomTimes
    var nextTimes: [DepartTime] = DepartTime.randomTimes
    
    var prevDepartureTimeText: String {
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let schedule = prevTimes.first { (schedule) -> Bool in
            let scheduleDateComponent = schedule.dateComponent
            guard let currentHour = currentDateComponents.hour, let scheduleHour = scheduleDateComponent.hour,
                let currentMinute = currentDateComponents.minute, let scheduleMinute = scheduleDateComponent.minute
                else {
                    return false
            }
            return scheduleHour >= currentHour && scheduleMinute >= currentMinute
        }
        
        return schedule?.timeText ?? prevTimes.first?.timeText ?? ""
    }
    
    var nextDepartureTimeText: String {
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let schedule = nextTimes.first { (schedule) -> Bool in
            let scheduleDateComponent = schedule.dateComponent
            guard let currentHour = currentDateComponents.hour, let scheduleHour = scheduleDateComponent.hour,
                let currentMinute = currentDateComponents.minute, let scheduleMinute = scheduleDateComponent.minute
                else {
                    return false
            }
            return scheduleHour >= currentHour && scheduleMinute >= currentMinute
        }
        
        return schedule?.timeText ?? nextTimes.first?.timeText ?? ""
    }
}

extension Station: Equatable {
    static func ==(lhs: Station, rhs: Station) -> Bool {
        lhs.id == rhs.id
    }
}

