//
//  API+VoIP.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension API {
    
    /*
    public class func getVoIPCallDetails(conferenceId: String, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        API.shared.get(endpoint: "/voip/callDetails/\(conferenceId)", success: { (json) in
            // TODO
        }, failure: failure)
    }
     */
}

//MARK: Request VoIP Token
extension API {
    public class func requestVoIPToken(_ request: RequestVoIPTokenRequest, success: @escaping (String) -> Void, failure: @escaping APIResponseFailureHandler) {
        API.shared.post(endpoint: "/voip/token", parameters: request.parameters, success: { (json) in
            guard let token = json["token"].string else {
                failure(nil)
                return
            }
            success(token)
        }, failure: failure)
    }
}

//MARK: Make VoIP Call
extension API {
    public class func makeVoIPCall(_ request: MakeVoIPCallRequest, success: @escaping (Bool) -> Void, failure: @escaping APIResponseFailureHandler) {
        API.shared.post(endpoint: "/voip/makeCall", parameters: request.parameters, success: { (json) in
            success(json["accepted"].boolValue)
        }, failure: failure)
    }
}

extension API {
    
    public class func acceptVoIPCall(uuid: String, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        let parameters: Parameters = [
            "accepted": true
        ]
        API.shared.post(endpoint: "/respondToMessage/\(uuid)", parameters: parameters, success: { (json) in
            success()
        }, failure: failure)
    }
    
    public class func rejectVoIPCall(uuid: String, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        let parameters: Parameters = [
            "accepted": true
        ]
        API.shared.post(endpoint: "/respondToMessage/\(uuid)", parameters: parameters, success: { (json) in
            success()
        }, failure: failure)
    }
    
    public class func submitVoIPPingReceived(_ uuid: String, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        shared.post(endpoint: "/receivedMessage/\(uuid)", success: { (json) in
            success()
        }, failure: failure)
    }
}
