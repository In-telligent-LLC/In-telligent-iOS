//
//  API+Alert.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/24/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Send Alert
extension API {
    class public func sendBuildingAlert(_ request: SendBuildingAlertRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/buildings/send_building_alert", parameters: request.parameters, success: { (json) in
            success()
        }, failure: failure)
    }
}

//MARK: Suggest Alert
extension API {
    class public func suggestBuildingAlert(_ request: SuggestBuildingAlertRequest, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/subscribers/suggestNotification", parameters: request.parameters, success: { (json) in
            success()
        }, failure: failure)
    }
}
