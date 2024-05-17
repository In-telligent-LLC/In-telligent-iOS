//
//  API+Notification.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/8/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension API {
    
    public class func getInbox(_ page: Int, success: @escaping (_ notifications: [INNotification], _ hasMoreData: Bool) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/subscribers/inbox/\(page)", success: { (json) in
            let notifications = INNotification.initMany(json: json["Notifications"])
            let hasMoreData = json["hasMoreData"].boolValue
            success(notifications, hasMoreData)
        }, failure: failure)
    }
    
    public class func getSaved(_ success: @escaping (_ notifications: [INNotification]) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/subscribers/savedMessages", success: { (json) in
            let notifications = INNotification.initMany(json: json["Notifications"])
            notifications.forEach({ $0.isSaved = true })
            success(notifications)
        }, failure: failure)
    }
    
    public class func getUnread(_ page: Int, success: @escaping (_ notifications: [INNotification], _ hasMoreData: Bool) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/subscribers/unreadMessages/\(page)", success: { (json) in
            let notifications = INNotification.initMany(json: json["Notifications"])
            let hasMoreData = json["hasMoreData"].boolValue
            success(notifications, hasMoreData)
        }, failure: failure)
    }
    
    public class func markOpened(_ notification: INNotification, success: (() -> Void)?, failure: APIResponseFailureHandler?) {
        let parameters: Parameters = [
            "notificationId": notification.id,
        ]
        shared.post(endpoint: "/subscribers/openedAlert", parameters: parameters, success: { (json) in
            if json["success"].boolValue {
                notification.isRead = true
                
                INNotification.updateUnreadBadgeCount()

                success?()
            } else {
                failure?(nil)
            }
        }, failure: failure)
    }
    
    public class func markDelivered(_ notificationId: String, success: (() -> Void)?, failure: APIResponseFailureHandler?) {
        let parameters: Parameters = [
            "notificationId": notificationId,
        ]
        shared.post(endpoint: "/subscribers/deliveredAlert", parameters: parameters, success: { (json) in
            if json["success"].boolValue {
                success?()
            } else {
                failure?(nil)
            }
        }, failure: failure)
    }
    
    public class func markPersonalSafetyResponse(_ notification: INNotification, viewed: Bool, success: (() -> Void)?, failure: APIResponseFailureHandler?) {
        let parameters: Parameters = [
            "notificationId": notification.id,
            "response": viewed ? 1: -1
        ]
        shared.post(endpoint: "/subscribers/personalSafetyResponse", parameters: parameters, success: { (json) in
            if json["success"].boolValue {
                success?()
            } else {
                failure?(nil)
            }
        }, failure: failure)
    }
    
    public class func toggleSaveNotification(_ notification: INNotification, isSaving: Bool, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        let parameters: Parameters = [
            "notificationId": notification.id,
            "action": isSaving ? "add": "remove"
        ]
        shared.post(endpoint: "/subscribers/savedMessages", parameters: parameters, success: { (json) in
            if json["success"].boolValue {
                success()
            } else {
                failure(nil)
            }
        }, failure: failure)
    }
    
    public class func deleteNotification(_ notification: INNotification, success: @escaping APIResponseSuccessVoidHandler, failure: @escaping APIResponseFailureHandler) {
        let parameters: Parameters = [
            "notificationId": notification.id
        ]
        shared.post(endpoint: "/subscribers/deletedAlert", parameters: parameters, success: { (json) in
            if json["success"].boolValue {
                success()
            } else {
                failure(nil)
            }
        }, failure: failure)
    }
    
    public class func getBuildingNotifications(_ buildingId: Int, success: @escaping (_ notifications: [INNotification]) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/buildings/allNotifications/\(buildingId)", success: { (json) in
            let notifications = INNotification.initMany(json: json["Notifications"])
            success(notifications)
        }, failure: failure)
    }
    
    public class func getBuildingNotificationDeliveryInfo(_ buildingId: Int, notificationId: Int, success: @escaping (_ notificationDeliveryInfo: NotificationDeliveryInfo) -> Void, failure: @escaping APIResponseFailureHandler) {
        shared.get(endpoint: "/buildings/\(buildingId)/delivery-info/\(notificationId)", success: { (json) in
            let notificationDeliveryInfo = NotificationDeliveryInfo(json: json)
            success(notificationDeliveryInfo)
        }, failure: failure)
    }
    
}
