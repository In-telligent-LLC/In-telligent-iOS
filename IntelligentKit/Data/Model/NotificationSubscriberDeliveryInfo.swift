//
//  NotificationDeliveryInfo.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/19/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct NotificationSubscriberDeliveryInfo {
    
    static public let yesImage = UIImage(named: "icon_check")?.withRenderingMode(.alwaysTemplate)
    static public let noImage = UIImage(named: "icon_x")?.withRenderingMode(.alwaysTemplate)

    public let buildingSubscriberName: String
    public let wasOpened: Bool
    public let wasDelivered: Bool
    
    init?(json: JSON) {
        buildingSubscriberName = json["Subscriber"]["name"].stringValue
        
        wasOpened = json["opened"].stringValue.count > 0
        wasDelivered = json["delivered"].stringValue.count > 0
    }

    static func initMany(json: JSON) -> [NotificationSubscriberDeliveryInfo] {
        var notificationDeliveryInfos: [NotificationSubscriberDeliveryInfo] = []
        for nJSON in json.arrayValue {
            if let notificationDeliveryInfo = NotificationSubscriberDeliveryInfo(json: nJSON) {
                notificationDeliveryInfos.append(notificationDeliveryInfo)
            }
        }
        return notificationDeliveryInfos
    }
    
}
