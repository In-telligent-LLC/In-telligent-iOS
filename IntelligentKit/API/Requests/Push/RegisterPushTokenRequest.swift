//
//  RegisterPushTokenRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct RegisterPushTokenRequest: APIRequest {
    let pushToken: String
    let environment: String = {
        #if DEBUG
        return "development"
        #else
        return "production"
        #endif
    }()
    
    public init(pushToken: String) {
        self.pushToken = pushToken
    }
    
    var parameters: Parameters {
        return [
            "pushToken": pushToken,
            "environment": environment
        ]
    }
}
