//
//  ValidateSignupRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct ValidateSignupRequest: APIRequest {
    let name: String
    let email: String

    public init(name: String, email: String) {
        self.name = name
        self.email = email
    }
    
    var parameters: Parameters {
        return [
            "name": name,
            "email": email
        ]
    }
}
