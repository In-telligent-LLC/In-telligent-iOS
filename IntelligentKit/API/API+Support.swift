//
//  API+Support.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Support
extension API {
    public class func submitSupportRequest(_ request: SupportRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        let parameters: Parameters = [
            "message": request.message
        ]
        shared.post(endpoint: "/subscribers/sendHelpEmail", parameters: parameters, success: { (json) in
            success()
        }, failure: failure)
    }
}
