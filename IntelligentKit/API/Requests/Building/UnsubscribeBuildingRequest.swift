//
//  UnsubscribeBuildingRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct UnsubscribeBuildingRequest: APIRequest {
    let buildingId: Int
    let automatic: Bool
    
    public init(buildingId: Int, automatic: Bool) {
        self.buildingId = buildingId
        self.automatic = automatic
    }
    
    var parameters: Parameters {
        let parameters: Parameters = [
            "actions": [
                [
                    "buildingId": buildingId,
                    "automatic": automatic ? 1: 0,
                    "action": "unsubscribe"
                ]
            ]
        ]
        return parameters
    }
}
