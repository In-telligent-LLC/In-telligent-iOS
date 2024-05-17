//
//  LocationFeedAlertRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct LocationFeedAlertRequest: APIRequest {
    let feedAlertId: Int
    let lat: Double
    let lng: Double
    let accuracy: Double
    
    public init(feedAlertId: Int, lat: Double, lng: Double, accuracy: Double) {
        self.feedAlertId = feedAlertId
        self.lat = lat
        self.lng = lng
        self.accuracy = accuracy
    }
    
    var parameters: Parameters {
        return [
            "lat": lat,
            "lng": lng,
            "accuracy": accuracy
        ]
    }
}
