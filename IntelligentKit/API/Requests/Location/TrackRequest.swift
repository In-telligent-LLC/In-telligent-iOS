//
//  TrackRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire
import CoreLocation

public struct TrackRequest: APIRequest {
    let buildingId: Int
    let isInside: Bool
    let location: CLLocation?
    
    public init(buildingId: Int, isInside: Bool, location: CLLocation?) {
        self.buildingId = buildingId
        self.isInside = isInside
        self.location = location
    }
    
    var parameters: Parameters {
        var parameters: Parameters = [
            "id": buildingId,
            "inside": isInside ? 1: 0,
            ]
        if let location = location {
            parameters["location"] = [
                "lat": location.coordinate.latitude,
                "lng": location.coordinate.longitude,
                "accuracy": location.horizontalAccuracy
            ]
        }
        return parameters
    }
}
