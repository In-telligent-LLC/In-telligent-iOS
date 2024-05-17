//
//  NotificationDeliveryInfo.swift
//  Intelligent
//
//  Created by Kurt Jensen on 12/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON

public class NotificationDeliveryInfo {

    public let totalCount: Int
    public let openedCount: Int
    public let deliveredCount: Int
    public let subscriberInfos: [NotificationSubscriberDeliveryInfo]
    
    init(json: JSON) {
        subscriberInfos = NotificationSubscriberDeliveryInfo.initMany(json: json["subscribers"])
        
        totalCount = json["sent"].intValue
        deliveredCount = json["delivered"].intValue
        openedCount = json["opened"].intValue
    }
}
