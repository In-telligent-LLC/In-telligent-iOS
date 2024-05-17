//
//  LoginPartnerRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct LoginPartnerRequest: APIRequest {
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    let email: String
    let password: String
    let partnerToken: String

    public init(email: String, password: String, partnerToken: String) {
        self.email = email
        self.password = password
        self.partnerToken = partnerToken
    }
    
    var parameters: Parameters {
        return [
            "deviceId": deviceId,
            "email": email,
            "password": password,
            "partnerToken": partnerToken
        ]
    }
}
