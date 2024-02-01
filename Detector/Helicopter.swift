//
//  Helicopter.swift
//  DTest Watch App
//
//  Created by PNT001 on 1/9/24.
//

import Foundation
import CoreLocation
import MapKit
import Combine

class Helicopter: NSObject, ObservableObject, CLLocationManagerDelegate {
    
//    var manager: CLLocationManager!
    let manager = CLLocationManager()
    
    @Published var long = 0.0
    @Published var lat = 0.0
    @Published var alt = 0.0
    
    override init() {
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }

    
    private func checkLcPermission(_ status: CLAuthorizationStatus) {

        switch status {
        case .authorizedAlways:
            manager.requestLocation()
            break
        case .authorizedWhenInUse, .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted, .denied:
            print("fail to authorize")
        default:
            print("what else....?")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location change detected")
        for location in locations {
            print("longitude",location.coordinate.longitude)
            print("latitude",location.coordinate.latitude)
            
            self.long = location.coordinate.longitude
            self.lat = location.coordinate.latitude
            // Altitude
            let altitude = location.altitude
            print("altitude : ",altitude)
            self.alt = altitude
            // Speed
            let speed = location.speed
            print("speed",speed)
            // Course, degrees relative to due north
            let source = location.course
            print("source",source)
            // Distance between two CLLocation
            // Given another CLLocation, otherLocation
//            let distance = location.distance(from: otherLocation)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLcPermission(manager.authorizationStatus)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("heading change detected")
    }
}


