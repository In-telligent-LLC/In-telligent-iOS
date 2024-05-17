//
//  INGeofenceUpdater.swift
//  ScaIntelligent
//
//  Created by Zachary Zeno on 11/19/15.
//  Copyright © 2015 Zachary Zeno. All rights reserved.
//

import Foundation
import CoreLocation

fileprivate func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

public class INGeofenceUpdater: NSObject {
    
    static let shared = INGeofenceUpdater()
    
    let locationManager: CLLocationManager
    var waitingForLocation = false

    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    class public func start() {
        shared.start()
    }
    
    private func start() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            Logging.info("Start refresh geofences")
            self.waitingForLocation = true
            locationManager.requestLocation()
        default:
            Logging.info("Cannot refresh geofences, need location authorization")
            break
        }
    }
    
}

extension INGeofenceUpdater: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
            !waitingForLocation else { return }
        
        waitingForLocation = false
        
        Logging.info("Got location for geofence refresh \(location)")
        
        let request = RefreshGeofencesRequest(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude,
            accuracy: location.horizontalAccuracy
        )
        API.refreshGeofences(request, success: nil, failure: nil)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logging.info("locationManager didFailWithError \(error)")
        Logging.info(error)
    }
}
