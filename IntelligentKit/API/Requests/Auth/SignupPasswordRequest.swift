//
//  SignupPasswordRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct SignupPasswordRequest: APIRequest {
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    let password: String
    let password2: String
    
    public init(password: String, password2: String) {
        self.password = password
        self.password2 = password2
    }
    
    var parameters: Parameters {
        return [
            "deviceId": deviceId,
            "password": password,
            "password2": password2
        ]
    }
}
