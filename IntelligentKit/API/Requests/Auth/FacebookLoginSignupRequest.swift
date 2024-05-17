//
//  FacebookLoginSignupRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct FacebookLoginSignupRequest: APIRequest {
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    let facebookAccessToken: String
    
    public init(facebookAccessToken: String) {
        self.facebookAccessToken = facebookAccessToken
    }
    
    var parameters: Parameters {
        return [
            "deviceId": deviceId,
            "facebookAccessToken": facebookAccessToken
        ]
    }
}
