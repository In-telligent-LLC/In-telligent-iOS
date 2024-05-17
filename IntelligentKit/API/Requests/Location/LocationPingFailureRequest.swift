//
//  LocationPingFailureRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct LocationPingFailureRequest: APIRequest {
    let uuid: String
    let success: Bool = false
    
    public init(uuid: String) {
        self.uuid = uuid
    }
    
    var parameters: Parameters {
        return [
            "success": success
        ]
    }
}
