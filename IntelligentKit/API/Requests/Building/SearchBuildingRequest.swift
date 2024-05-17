//
//  SearchBuildingRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire
import CoreLocation

public struct SearchBuildingRequest: APIRequest {
    let query: String
    let coordinate: CLLocationCoordinate2D?
    // TODO page?

    public init(query: String, coordinate: CLLocationCoordinate2D? = nil) {
        self.query = query
        self.coordinate = coordinate
    }
    
    var parameters: Parameters {
        var parameters: [String: Any] = [
            "query": query
        ]
        if let coordinate = coordinate {
            parameters["lat"] = coordinate.latitude
            parameters["lng"] = coordinate.longitude
        }
        return parameters
    }
}
