//
//  API+Location.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/9/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

//MARK: Location Ping
extension API {
    public class func submitLocationPingFailure(_ request: LocationPingFailureRequest, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/receivedMessage/\(request.uuid)", parameters: request.parameters, success: { (json) in
            success?()
        }, failure: failure)
    }
}

extension API {
    public class func submitLocationPingSuccess(_ request: LocationPingSuccessRequest, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/receivedMessage/\(request.uuid)", parameters: request.parameters, success: { (json) in
            success?()
        }, failure: failure)
    }
}

extension API {

    public class func submitLocationFeedAlert(_ request: LocationFeedAlertRequest, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/feed-alerts/send/\(request.feedAlertId)", parameters: request.parameters, success: { (json) in
            success?()
        }, failure: failure)
    }
}

//MARK: Track
extension API {

    public class func track(_ request: TrackRequest, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/subscribers/trackUser", parameters: request.parameters, success: { (json) in
            success?()
        }, failure: failure)
    }
}

//MARK: Get Lat Location
extension API {
    public class func getLastKnownLocation(_ request: LastLocationRequest, success: @escaping (CLLocationCoordinate2D) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/location-ping/get-subscriber-last-known/\(request.subscriberId)", success: { (json) in
            if json["success"].boolValue {
                let coordinate = CLLocationCoordinate2D(latitude: json["lat"].doubleValue, longitude: json["lng"].doubleValue)
                success(coordinate)
            } else {
                failure(nil)
            }
        }, failure: failure)
    }
    
    public class func getCurrentLocation(_ request: LastLocationRequest, success: @escaping (CLLocationCoordinate2D) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/location-ping/get-subscriber/\(request.subscriberId)", success: { (json) in
            if json["success"].boolValue {
                let coordinate = CLLocationCoordinate2D(latitude: json["lat"].doubleValue, longitude: json["lng"].doubleValue)
                success(coordinate)
            } else {
                failure(nil)
            }
        }, failure: failure)
    }
}
