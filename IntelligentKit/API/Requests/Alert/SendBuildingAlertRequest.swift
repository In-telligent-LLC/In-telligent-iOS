//
//  SendBuildingAlertRequest.swift
//  IntelligentKit
//
//  Created by Kurt Jensen on 12/6/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Alamofire

public struct SendBuildingAlertRequest: APIRequest {
    let title: String
    let message: String
    let building: INBuilding
    let attachments: [CustomImage]
    let notificationType: NotificationType
    let sendTo: SendTo
    let specifiedSubscribers: [BuildingSubscriber]
    let deliverTo: DeliverTo
    
    public init(title: String, message: String, building: INBuilding, attachments: [CustomImage], notificationType: NotificationType, sendTo: SendTo, specifiedSubscribers: [BuildingSubscriber], deliverTo: DeliverTo) {
        self.title = title
        self.message = message
        self.building = building
        self.attachments = attachments
        self.notificationType = notificationType
        self.sendTo = sendTo
        self.specifiedSubscribers = specifiedSubscribers
        self.deliverTo = deliverTo
    }
    
    var parameters: Parameters {
        var parameters: Parameters = [
            "title": title,
            "body": message,
            "buildingId": "\(building.id)",
            "type": notificationType.rawValue,
            "subscription": sendTo.rawValue,
            "send_to_email": deliverTo.rawValue
        ]
        if specifiedSubscribers.count > 0 {
            let ids: [Int] = specifiedSubscribers.map({ return $0.subscriberId })
            parameters["subscribers"] = ids
        }
        if attachments.count > 0 {
            var attachments: [[String: Any]] = []
            for attachment in self.attachments {
                attachments.append([
                    "data": attachment.imageData?.base64EncodedString() ?? "",
                    "name": attachment.imageName ?? ""
                ])
            }
            parameters["attachment"] = attachments
        }
        return parameters
    }
}
