//
//  LocationManager.swift
//  WeedmapsChallenge
//
//  Created by Perez Willie-Nwobu on 3/5/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var location: (lat: Double, lon: Double)?
    
    override init() {
        super.init()
        manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let clLocation = manager.location?.coordinate else { location = nil; return }
        location = (lat: clLocation.latitude, lon: clLocation.longitude)
    }
}
