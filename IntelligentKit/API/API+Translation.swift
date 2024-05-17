//
//  API+Translation.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension API {
    
    public class func getAllLanguages(_ success: @escaping (_ languages: [Language]) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/subscribers/listLanguages", success: { (json) in
            var languages: [Language] = []
            for lJSON in json["languages"].arrayValue {
                let language = Language(json: lJSON)
                languages.append(language)
            }
            success(languages)
        }, failure: failure)
    }
    
    public class func getTranslation(for notification: INNotification, to language: Language, success: @escaping (_ translation: Translation) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/buildings/translateAlert/\(notification.id)/\(language.code)", success: { (json) in
            let title = json["title"].stringValue
            let body = json["body"].stringValue
            let translation = Translation(
                notificationId: notification.id,
                language: language,
                title: title,
                message: body
            )
            success(translation)
        }, failure: failure)
    }
}
