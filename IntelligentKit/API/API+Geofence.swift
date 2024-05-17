//
//  API+Geofence.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/14/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Geofencing
extension API {
    public class func refreshGeofences(_ request: RefreshGeofencesRequest, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/subscribers/refreshGeofences", parameters: request.parameters, success: { (json) in
            if let subscriber = INSubscriber(json: json["Subscriber"]) {
                INSubscriberManager.updateCurrentSubscriber(subscriber)
            }
            success?()
        }, failure: failure)
    }
}

//MARK: Get All Beacons
extension API {
    
    public class func getNewGeofences(_ request: GetNewGeofencesRequest, success: @escaping (_ geofences: [String: IntelligentGeofence] ) -> Void, failure: APIResponseFailureHandler?) {
        shared.get(endpoint: "/geofences_new/byLocation", parameters: request.parameters, success: { (json) in
            var geofences: [String: IntelligentGeofence] = [:]
            for geofenceJSON in json["geofences"].arrayValue {
                let geofence = IntelligentGeofence(json: geofenceJSON)
                geofences[geofence.idString] = geofence
            }
            success(geofences)
        }, failure: failure)
    }
    
    public class func getGeofenceById(_ id: String, success: @escaping (_ geofence: IntelligentGeofence) -> Void, failure: APIResponseFailureHandler?) {
        shared.get(endpoint: "/geofences_new/get/\(id)", success: { (json) in
            let geofence = IntelligentGeofence(json: json["geofence"])
            success(geofence)
        }, failure: failure)
    }
}

extension API {
    
    public class func getAllBeacons(_ success: @escaping (_ beaconsByBuilding: [Int: [IntelligentBeacon]] ) -> Void, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/subscribers/refreshGeofences", success: { (json) in
            var beaconsByBuilding: [Int: [IntelligentBeacon]] = [:]
            for buildingJSON in json["Buildings"].arrayValue {
                let buildingId = buildingJSON["id"].intValue
                
                var beacons: [IntelligentBeacon] = []
                for beaconJSON in buildingJSON["beacons"].arrayValue {
                    let beacon = IntelligentBeacon(json: beaconJSON)
                    beacons.append(beacon)
                }
                
                beaconsByBuilding[buildingId] = beacons
            }
            success(beaconsByBuilding)
        }, failure: failure)
    }
}
