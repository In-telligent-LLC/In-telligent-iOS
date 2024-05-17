//
//  SubscribeBuildingRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct SubscribeBuildingRequest: APIRequest {
    let buildingId: Int
    let automatic: Bool
    let inviteId: Int?
    let optIn: Bool
    
    public init(buildingId: Int, automatic: Bool, inviteId: Int?, optIn: Bool) {
        self.buildingId = buildingId
        self.automatic = automatic
        self.inviteId = inviteId
        self.optIn = optIn
    }
    
    var parameters: Parameters {
        var actionParameters: Parameters = [
            "buildingId": buildingId,
            "automatic": automatic ? 1: 0,
            "action": "subscribe"
        ]
        if let inviteId = inviteId {
            actionParameters["inviteId"] = inviteId
        }
        let parameters: Parameters = [
            "actions": [actionParameters]
        ]
        return parameters
    }
}
