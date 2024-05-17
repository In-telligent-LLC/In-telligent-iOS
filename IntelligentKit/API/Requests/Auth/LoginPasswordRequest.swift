//
//  LoginPasswordRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire

public struct LoginPasswordRequest: APIRequest {
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    let email: String
    let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    var parameters: Parameters {
        return [
            "deviceId": deviceId,
            "email": email,
            "password": password
        ]
    }
}
