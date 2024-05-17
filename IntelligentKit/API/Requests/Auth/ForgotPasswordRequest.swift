//
//  ForgotPasswordRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct ForgotPasswordRequest: APIRequest {
    let email: String
    
    public init(email: String) {
        self.email = email
    }
    
    var parameters: Parameters {
        return [
            "email": email
        ]
    }
}
