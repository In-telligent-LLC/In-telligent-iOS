//
//  NotificationName.swift
//  Open API
//
//  Created by Zachary Zeno on 3/13/18.
//  Copyright © 2018 In-telligent LLC. All rights reserved.
//

import Foundation

extension Foundation.Notification.Name {
    static public let receivedPushNotification = Foundation.Notification.Name("receivedPushNotification")
    static public let receivedAutomaticAlert = Foundation.Notification.Name("receivedAutomaticAlert")
    static public let callBuildingManager = Foundation.Notification.Name("callBuildingManager")
    static public let resetInbox = Foundation.Notification.Name("resetInbox")
    static public let incomingCall = Foundation.Notification.Name("incomingCall")
    static public let updatedBannerAd = Foundation.Notification.Name("updatedBannerAd")
}
