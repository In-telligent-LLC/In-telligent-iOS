//
//  API+Push.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

//MARK: Register Push Token
extension API {
    public class func registerPushToken(_ request: RegisterPushTokenRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/subscribers/registerPush", parameters: request.parameters, success: { (json) in
            let result = json["success"].boolValue
            if result {
                success()
            } else {
                let error = INError(json: json)
                failure(error)
            }
        }, failure: failure)
    }
}
