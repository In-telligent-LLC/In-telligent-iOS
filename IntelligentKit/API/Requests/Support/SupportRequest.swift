//
//  SupportRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct SupportRequest: APIRequest {
    let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    var parameters: Parameters {
        return [
            "message": message
        ]
    }
}
