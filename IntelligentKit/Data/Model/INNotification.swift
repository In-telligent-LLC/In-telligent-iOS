//
//  INNotification.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON

public class INNotification: NSObject {
    
    public let id: Int
    public let buildingId: Int?
    
    public let title: String
    public let message: String
    
    public let attachments: [NotificationAttachment]
    
    public let language: String
    
    private let _startDate: String
    public var startDate: Date? {
        return DateFormatter.isoDateFormatter.date(from: _startDate)
    }
    
    public let senderId: Int?
    public let senderEmail: String?
    
    public var isRead: Bool
    public var isSaved: Bool

    public let type: NotificationType
    
    public var info: String {
        var infos: [String] = []
        if let startDateString = startDate?.formatted(with: DateFormatter.shortDateTimeFormatter) {
            infos.append(startDateString)
        }
        infos.append(type.localizedString)
        if let buildingName = getBuilding()?.name {
            infos.append(buildingName)
        }
        return infos.joined(separator: ", ")
    }
    
    init?(json: JSON) {
        id = json["id"].intValue
        
        buildingId = json["Building"]["id"].int ?? json["buildingId"].int
        
        title = json["title"].stringValue
        message = json["description"].stringValue
        
        _startDate = json["startDate"].stringValue
        
        language = json["language"].stringValue
        
        isRead = json["NotificationsSubscriber", "opened"].type != .null
        isSaved = json["isSaved"].boolValue

        type = NotificationType(rawValue: json["type"].stringValue) ?? .normal
        
        var attachments: [NotificationAttachment] = []
        for attachmentJSON in json["NotificationAttachments"].arrayValue {
            if let attachment = NotificationAttachment(
                url: attachmentJSON["url"].stringValue,
                type: NotificationAttachmentType(rawValue: attachmentJSON["type"].stringValue) ?? .unknown
                ) {
                attachments.append(attachment)
            }
        }
        self.attachments = attachments
        
        senderId = json["senderId"].int
        senderEmail = json["senderEmail"].string        
    }
    
    static func initMany(json: JSON) -> [INNotification] {
        var notifications: [INNotification] = []
        for nJSON in json.arrayValue {
            if let notification = INNotification(json: nJSON) {
                notifications.append(notification)
            }
        }
        return notifications
    }
    
    public func getBuilding() -> INBuilding? {
        guard let buildingId = buildingId else { return nil }
        
        return INSubscriber.current?.getSubscribedBuilding(buildingId)
    }
    
    static public func updateUnreadBadgeCount() {
        if let _ = INSubscriber.current {
            API.getUnreadCount({ (unreadCount) in
                UIApplication.shared.applicationIconBadgeNumber = unreadCount
            }, failure: nil)
        }
    }
    
}
