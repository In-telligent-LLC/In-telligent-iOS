//
//  LastLocationRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct LastLocationRequest: APIRequest {
    let subscriberId: Int
    
    public init(subscriberId: Int) {
        self.subscriberId = subscriberId
    }
    
    var parameters: Parameters {
        return [:]
    }
}
