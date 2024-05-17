//
//  GetNewGeofencesRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct GetNewGeofencesRequest: APIRequest {
    let lat: Double
    let lng: Double
    
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
    
    var parameters: Parameters {
        return [
            "lat": lat,
            "lng": lng
        ]
    }
}
