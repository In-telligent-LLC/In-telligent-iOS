//
//  GoogleLoginSingupRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct GoogleLoginSignupRequest: APIRequest {
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    let googleAccessToken: String
    
    public init(googleAccessToken: String) {
        self.googleAccessToken = googleAccessToken
    }
    
    var parameters: Parameters {
        return [
            "deviceId": deviceId,
            "googleAccessToken": googleAccessToken
        ]
    }
}
