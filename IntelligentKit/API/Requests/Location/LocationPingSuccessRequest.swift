//
//  LocationPingSuccessRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct LocationPingSuccessRequest: APIRequest {
    let uuid: String
    let success: Bool = true
    let lat: Double
    let lng: Double
    let accuracy: Double
    
    public init(uuid: String, lat: Double, lng: Double, accuracy: Double) {
        self.uuid = uuid
        self.lat = lat
        self.lng = lng
        self.accuracy = accuracy
    }
    
    var parameters: Parameters {
        return [
            "success": success,
            "lat": lat,
            "lng": lng,
            "radius": accuracy
        ]
    }
}
