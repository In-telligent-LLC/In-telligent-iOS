//
//  API+Subscriber.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension API {
    public class func setWeatherAlertSounds(isWeatherEnabled: Bool? = nil, isLightningEnabled: Bool? = nil, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        var parameters: Parameters = [:]
        if let isWeatherEnabled = isWeatherEnabled {
            parameters["weatherAlertEnabled"] = isWeatherEnabled
        }
        if let isLightningEnabled = isLightningEnabled {
            parameters["lightningAlertEnabled"] = isLightningEnabled
        }
        syncMetadata(subscriber: parameters, success: success, failure: failure)
    }
    
    public class func changeMyLanguage(to language: Language, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        let parameters: Parameters = [
            "language": language.code
        ]
        syncMetadata(subscriber: parameters, success: success, failure: failure)
    }
    
    private class func syncMetadata(subscriber: Parameters? = nil, success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        var parameters: Parameters = [:]
        if let subscriber = subscriber {
            parameters["subscriber"] = subscriber
        }
        shared.post(endpoint: "/subscribers/syncMetadata", parameters: parameters, success: { (json) in
            if let subscriber = INSubscriber(json: json["Subscriber"]) {
                INSubscriberManager.updateCurrentSubscriber(subscriber)
            }
            success?()
        }, failure: failure)
    }
    
    public class func getUnreadCount(_ success: @escaping (_ unreadCount: Int) -> Void, failure: APIResponseFailureHandler?) {
        shared.get(endpoint: "/subscribers/getUnreadCount", success: { (json) in
            if json["success"].boolValue {
                let unreadCount = json["unreadCount"].intValue
                success(unreadCount)
            } else {
                failure?(nil)
            }
        }, failure: failure)
    }
    
    public class func openedApp(_ success: APIResponseSuccessVoidHandler?, failure: APIResponseFailureHandler?) {
        shared.post(endpoint: "/subscribers/openedApp", success: { (json) in
            if json["success"].boolValue {
                success?()
            } else {
                failure?(nil)
            }
        }, failure: failure)
    }
}
