//
//  AutoSubscribeOptRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct AutoSubscribeOptRequest: APIRequest {
    let buildingId: Int
    let optOut: Bool
    
    public init(buildingId: Int, optOut: Bool) {
        self.buildingId = buildingId
        self.optOut = optOut
    }
    
    var parameters: Parameters {
        return [
            "buildingId": buildingId,
            "value": optOut ? 1 : 0
        ]
    }
}
