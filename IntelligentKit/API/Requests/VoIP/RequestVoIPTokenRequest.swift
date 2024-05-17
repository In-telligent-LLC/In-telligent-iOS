//
//  RequestVoIPTokenRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct RequestVoIPTokenRequest: APIRequest {
    let isCM: Bool

    public init(isCM: Bool) {
        self.isCM = isCM
    }
    
    var parameters: Parameters {
        return [
            "isCM": isCM
        ]
    }
}
