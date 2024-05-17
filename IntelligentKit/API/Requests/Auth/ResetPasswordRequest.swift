//
//  ResetPasswordRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//


import Alamofire

public struct ResetPasswordRequest: APIRequest {
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    let resetCode: String
    let password: String
    let password2: String
    
    public init(resetCode: String, password: String, password2: String) {
        self.resetCode = resetCode
        self.password = password
        self.password2 = password2
    }
    
    var parameters: Parameters {
        return [
            "deviceId": deviceId,
            "resetCode": resetCode,
            "password": password,
            "password2": password2
        ]
    }
}
