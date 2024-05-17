//
//  LocationManager.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/9/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import CoreLocation

public class INLocationManager: NSObject {
    
    static let shared = INLocationManager()
    
    private let locationManager = CLLocationManager()
    
    class public func start() {
        shared.start()
    }
    
    class public func ping(uuid: String) {
        getUserLocation({ (location) in
            let request = LocationPingSuccessRequest(
                uuid: uuid,
                lat: location.coordinate.latitude,
                lng: location.coordinate.longitude,
                accuracy: location.horizontalAccuracy
            )
            API.submitLocationPingSuccess(request, success: nil, failure: nil)
        }) { (error) in
            let request = LocationPingFailureRequest(
                uuid: uuid
            )
            API.submitLocationPingFailure(request, success: nil, failure: nil)
        }
    }
    
    class public func pingFeedAlert(feedAlertId: Int) {
        getUserLocation({ (location) in
            let request = LocationFeedAlertRequest(
                feedAlertId: feedAlertId,
                lat: location.coordinate.latitude,
                lng: location.coordinate.longitude,
                accuracy: location.horizontalAccuracy
            )
            API.submitLocationFeedAlert(request, success: nil, failure: nil)
        }, failure: { (error) in
            //
        })
    }
    
    class public func getCurrentCountryCode(_ success: @escaping (String) -> (), failure: @escaping (Error?) -> ()) {
        guard let location = shared.locationManager.location else {
            failure(nil)
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let placemark = placemarks?.first, let countryCode = placemark.isoCountryCode {
                success(countryCode)
            } else {
                failure(error)
            }
        })
    }
}

extension INLocationManager {
    private func start() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways,
             .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

extension INLocationManager: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
    }
    
    class func getUserLocation(_ success: @escaping (CLLocation) -> (), failure: @escaping (Error?) -> ()) {
        guard let location = shared.locationManager.location else {
            getApproximateUserLocation(success, failure: failure)
            return
        }
        
        success(location)
    }
    
    class func getApproximateUserLocation(_ success: @escaping (CLLocation) -> (), failure: @escaping (Error?) -> ()) {
        let geocoder = CLGeocoder()
        let zip = INSubscriber.current?.zipcode
        geocoder.geocodeAddressString(zip ?? "") {
            placemarks, error in
            if let location = placemarks?.first?.location {
                success(location)
            } else {
                failure(error)
            }
        }
    }
    
}
