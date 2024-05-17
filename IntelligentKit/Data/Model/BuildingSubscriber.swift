//
//  BuildingSubscriber.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/2/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct BuildingSubscriber: Hashable {
    
    public var hashValue: Int {
        return id
    }
    
    public let id: Int
    public let subscriberId: Int
    public let name: String
    public let phoneNumber: String?
    public let email: String?
    public let status: BuildingSubscriberStatus

    init?(json: JSON) {
        guard let id = json["id"].int else { return nil }
        
        self.id = id
        self.subscriberId = json["subscriberId"].intValue
        self.name = json["name"].stringValue
        self.phoneNumber = json["phoneNumber"].string
        self.email = json["email"].string
        self.status = BuildingSubscriberStatus(rawValue: json["status"].stringValue) ?? .none
    }
    
    static func initMany(json: JSON) -> [BuildingSubscriber] {        
        var subscribers: [BuildingSubscriber] = []
        for sJSON in json.arrayValue {
            if let subscriber = BuildingSubscriber(json: sJSON) {
                subscribers.append(subscriber)
            }
        }
        return subscribers
    }
}
