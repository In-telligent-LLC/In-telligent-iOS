//
//  InviteSubscriberRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct InviteSubscriberRequest: APIRequest {
    let building: Building
    let name: String
    let phoneNumber: String?
    let email: String?
    
    public init(building: Building, name: String, phoneNumber: String?, email: String?) {
        self.building = building
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
    }
    
    var parameters: Parameters {
        var recipient: Parameters = [
            "name": name,
            ]
        if let phoneNumber = phoneNumber {
            recipient["phone"] = phoneNumber
        }
        if let email = email {
            recipient["email"] = email
        }
        let parameters: Parameters = [
            "recipients": [recipient]
        ]
        return parameters
    }
}
