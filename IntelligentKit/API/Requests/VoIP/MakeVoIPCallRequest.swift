//
//  MakeVoIPCallRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct MakeVoIPCallRequest: APIRequest {
    let isCM: Bool
    let buildingId: Int
    let subscriberId: Int
    let conferenceId: String
    
    public init(isCM: Bool, buildingId: Int, subscriberId: Int, conferenceId: String) {
        self.isCM = isCM
        self.buildingId = buildingId
        self.subscriberId = subscriberId
        self.conferenceId = conferenceId
    }
    
    var parameters: Parameters {
        return [
            "isCM": isCM,
            "conferenceId": conferenceId,
            "senderId": subscriberId,
            "buildingId": buildingId
        ]
    }
}
