//
//  Geofencer.swift
//  ScaIntelligent
//
//  Created by Zachary Zeno on 2/9/15.
//  Copyright (c) 2015 Zachary Zeno. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

public struct IntelligentGeofence {
    let id: Int
    let type: String
    let idString: String
    let name: String
    let radius: Int
    let lat: Double
    let lng: Double
    let location: CLLocation
    let secure: Bool
    let priority: Int
    
    init(json: JSON) {
        id = json["id"].intValue
        type = json["type"].stringValue
        idString = "\(type)-\(id)"
        name = json["name"].stringValue
        radius = json["radius"].intValue
        
        lat = json["lat"].doubleValue
        lng = json["lng"].doubleValue
        location = CLLocation(latitude: lat, longitude: lng)
        
        secure = json["secure"].boolValue
        priority = json["priority"].intValue
    }
}

private var _geofences: [String: IntelligentGeofence]?

public class INGeofencer: NSObject {
    
    static let shared = INGeofencer()

    class public func geofences(with location: CLLocation, _ callback: @escaping ([String: IntelligentGeofence]) -> ()) {
        let request = GetNewGeofencesRequest(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
        API.getNewGeofences(request, success: { (geofences) in
            _geofences = geofences
            callback(geofences)
        }) { (error) in
            //
        }
    }
    
    class public func getGeofence(with idString: String, _ callback: @escaping (IntelligentGeofence) -> ()) {
        API.getGeofenceById(idString, success: callback) { (error) in
            //
        }
    }
    
    class public func start() {
        shared.registerLocationManager()
    }
    
    let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    private func registerLocationManager() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        switch(authorizationStatus) {
            
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            
        case .authorizedAlways:
            registerOnAuthorized()
            
        default:
            break
        }
    }
    
    func registerOnAuthorized() {
        locationManager.requestLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    @discardableResult func registerGeofenceRegion(_ id: String, lat: Double, lng: Double, radius: Double) -> CLRegion {
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let region = CLCircularRegion(center: coord, radius: Double(radius), identifier: id)
        locationManager.startMonitoring(for: region)
        return region
    }
    
    func registerBeaconRegion(_ id: String, uuid: UUID, major: CLBeaconMajorValue? = nil, minor: CLBeaconMinorValue? = nil) {
        let region: CLBeaconRegion
        
        if let major = major, let minor = minor {
            region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: id)
        } else if let major = major {
            region = CLBeaconRegion(proximityUUID: uuid, major: major, identifier: id)
        } else {
            region = CLBeaconRegion(proximityUUID: uuid, identifier: id)
        }
        
        Logging.info("Registering beacon region \(region)")
        
        locationManager.startMonitoring(for: region)
    }
    
    func deregisterGeofenceRegion(_ id: String) {
        for region in locationManager.monitoredRegions {
            if region.identifier == id {
                locationManager.stopMonitoring(for: region)
            }
        }
    }
    
    func clearRegions() {
        let locationManager = self.locationManager
        for region: CLRegion in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        
        for region: CLRegion in locationManager.rangedRegions {
            if let beaconRegion = region as? CLBeaconRegion {
                locationManager.stopRangingBeacons(in: beaconRegion)
            }
            else {
                Logging.info("Error non beacon region in rangedRegions")
            }
        }
    }
    
    func listRegions() {
        let locationManager = self.locationManager
        
        for region: CLRegion in locationManager.monitoredRegions {
            Logging.info(region)
        }
        for region: CLRegion in locationManager.rangedRegions {
            Logging.info(region)
        }
    }
    
    class func createNotificationForAutomaticAlert(_ buildingId: Int) {
        if let building = INSubscriber.current?.getSubscribedBuilding(buildingId) {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            let now = formatter.string(from: Date())
            
            Logging.info("Processing auto alert for building \(buildingId)")
            
            for alert in building.automaticAlerts {
                
                Logging.info("Alert \(alert.name) from \(alert.startTime) to \(alert.endTime)")
                
                if alert.startTime <= now && alert.endTime >= now {
                    Logging.info("Showing alert")
                    
                    let localNotification = UILocalNotification()
                    localNotification.userInfo = [
                        "action": "AutomaticAlert",
                        "building_name": building.name ?? "",
                        "alert_body": alert.description
                    ]
                    localNotification.fireDate = Date()
                    localNotification.alertTitle = alert.name
                    localNotification.alertBody = alert.description
                    UIApplication.shared.scheduleLocalNotification(localNotification)
                    
                    break
                }
            }
        }
    }
    
}

extension INGeofencer: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch(status) {
        case .authorizedAlways:
            registerOnAuthorized()
        default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let request = RefreshGeofencesRequest(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude,
            accuracy: location.horizontalAccuracy
        )
        API.refreshGeofences(request, success: nil, failure: nil)
        
        clearRegions()
        
        BeaconWatcher.beacons {
            beacons in
            
            for buildingId in beacons.keys {
                self.registerBeaconRegion("beacon-\(buildingId)", uuid: BeaconWatcher.beaconUUID, major: UInt16(buildingId))
            }
        }
        
        INGeofencer.geofences(with: location) {
            geofences in
            
            Logging.info("Registering new intelligent fence")
            
            var sortedGeofences = Array(geofences.values)
            
            sortedGeofences.sort {
                a, b in
                
                let distA = location.distance(from: a.location)
                let distB = location.distance(from: b.location)
                
                return distA <= distB
            }
            
            var _lastGeofence: IntelligentGeofence?
            for (geofence) in sortedGeofences[0..<19] {
                self.registerGeofenceRegion(geofence.idString, lat: geofence.lat, lng: geofence.lng, radius: Double(geofence.radius))
                _lastGeofence = geofence
            }
            
            if let lastGeofence = _lastGeofence {
                let dist =  lastGeofence.location.distance(from: location)
                
                Logging.info("IntelligentFence radius: \(dist) to geofence name: \(lastGeofence.name)")
                self.registerGeofenceRegion("IntelligentFence", lat: location.coordinate.latitude, lng: location.coordinate.longitude, radius: dist)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        let stateString = state == .unknown ? "Unknown": (state == .inside ? "Inside": "Outside")
        
        Logging.info("Got region state for \(region): \(stateString)")
        
        switch state {
        case .inside:
            enteredRegion(region: region)
        case .outside:
            leftRegion(region: region)
        case .unknown:
            Logging.info("Got unknown state for region \(region)")
        }
    }
    
    func enteredRegion(region: CLRegion) {
        if region.identifier.hasPrefix("beacon-") {
            Logging.info("Entered \(region.identifier)")
            Logging.info(region);
            let beaconRegion = region as! CLBeaconRegion
            BeaconWatcher.shared.startTrackingBeacons(buildingId: beaconRegion.major as! Int)
            return
        }
        
        if region.identifier == "IntelligentFence" {
            Logging.info("Entered Intelligent Fence")
            return
        }
        
        INGeofencer.getGeofence(with: region.identifier) {
            geofence in
            
            Logging.info("Entered Region: \(geofence.name)")
            
            if geofence.type == "building" {
                self.handleSubscribeBuildingGeofence(geofence)
            } else if geofence.type == "weather-alert" {
                API.sendWeatherAlert(geofence.id, success: nil, failure: nil)
            }
        }
    }
    
    private func handleSubscribeBuildingGeofence(_ geofence: IntelligentGeofence) {
        guard let subscriber = INSubscriber.current else { return }
        
        let request = TrackRequest(buildingId: geofence.id, isInside: true, location: locationManager.location)
        API.track(request, success: nil, failure: nil)
        
        if subscriber.isSubscribed(to: geofence.id) {
            INGeofencer.createNotificationForAutomaticAlert(geofence.id)
        } else if !geofence.secure {
            if subscriber.isAutoSubscribed(to: geofence.id) {
                return
            }
            
            let request = SubscribeBuildingRequest(buildingId: geofence.id, automatic: true, inviteId: nil, optIn: false)
            API.subscribeToBuilding(request, success: {
                Logging.info("subscribed to \(geofence.name)")
                
                if subscriber.isSubscribed(to: geofence.id) {
                    INGeofencer.createNotificationForAutomaticAlert(geofence.id)
                    return
                }
            }, failure: { (error) in
                //
            })
        }
    }
    
    func leftRegion(region: CLRegion) {
        if region.identifier.hasPrefix("beacon-") {
            Logging.info("Left \(region.identifier)");
            Logging.info(region);
            let beaconRegion = region as! CLBeaconRegion
            BeaconWatcher.shared.stopTrackingBeacons(buildingId: beaconRegion.major as! Int)
            return
        }
        
        if region.identifier == "IntelligentFence" {
            Logging.info("Left Intelligent Fence")
            registerLocationManager()
            return
        }
        
        INGeofencer.getGeofence(with: region.identifier) {
            geofence in
            Logging.info("Left Region: \(geofence.name)")
            
            if geofence.type == "building" {
                self.handleUnSubscribeBuildingGeofence(geofence)
            }
        }
    }
    
    private func handleUnSubscribeBuildingGeofence(_ geofence: IntelligentGeofence) {
        guard let subscriber = INSubscriber.current else { return }
        
        let request = TrackRequest(buildingId: geofence.id, isInside: false, location: locationManager.location)
        API.track(request, success: nil, failure: nil)
        
        if subscriber.isSubscribed(to: geofence.id) && subscriber.isAutoSubscribed(to: geofence.id) {
            let request = UnsubscribeBuildingRequest(buildingId: geofence.id, automatic: true)
            API.unsubscribeFromBuilding(request, success: nil, failure: nil)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        Logging.info("Error monitoring geofences \(error)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        Logging.info("Got beacon ranging for region \(region)")
        for beacon in beacons {
            Logging.info(beacon)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        Logging.info("Error monitoring beacons \(error)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logging.info("locationManager didFailWithError")
        Logging.info(error)
    }
}
