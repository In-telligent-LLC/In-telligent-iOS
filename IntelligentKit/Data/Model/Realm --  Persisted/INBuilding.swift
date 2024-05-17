//
//  Building.swift
//  Intelligent
//
//  Created by Kurt on 10/12/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

public class INBuilding: Object, Building {

    override static public func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic public var id: Int = 0
    
    @objc dynamic public var name: String?
    @objc dynamic public var info: String?
    @objc dynamic public var websiteURL: String?
    @objc dynamic public var imageURL: String?
    @objc dynamic public var password: String?

    @objc dynamic public var subscriber: INBuildingSubscription?
    @objc dynamic public var subscriberId: Int = 0
    
    @objc dynamic public var isManagedByCurrentUser: Bool = false
    @objc dynamic public var isSubscribedByCurrentUser: Bool = false

    @objc dynamic public var isPersonal: Bool = false
    @objc dynamic public var isVirtual: Bool = false
    @objc dynamic public var isVoipEnabled: Bool = false
    @objc dynamic public var isTextEnabled: Bool = false

    @objc dynamic public var createdAt: Date?

    @objc dynamic private var _filterCategory: String = ""
    var automaticAlerts = List<INBuildingAutomaticAlert>()

    convenience init?(json: JSON, currentSubscriberId: Int, isSubscribed: Bool, managedBuildingIds: [Int]) {
        guard let id = json["id"].int else { return nil }
        
        self.init()
        
        self.id = id
        self.name = json["name"].string
        if let imageURL = json["BuildingCategory"]["BuildingCategoryImages"].array?.first?["image"].string {
            if imageURL.starts(with: "http") {
                self.imageURL = imageURL
            } else {
                self.imageURL = "https://app.in-telligent.com/img/categories/\(imageURL)"
            }
        }
        self.info = json["description"].string
        self.websiteURL = json["website"].string
        self.password = json["password"].string
        self.subscriberId = json["subscriberId"].intValue
        self.subscriber = INBuildingSubscription(buildingId: id, json: json["BuildingsSubscriber"])
        self.isPersonal = self.subscriberId > 0
        
        self.isSubscribedByCurrentUser = isSubscribed
        self.isManagedByCurrentUser = self.subscriberId == currentSubscriberId || managedBuildingIds.contains(id)

        isVirtual = json["BuildingAddress"]["isVirtual"].boolValue
        isVoipEnabled = json["isVoipEnabled"].intValue > 0
        isTextEnabled = json["isTextEnabled"].intValue == 1
        
        _filterCategory = subscriberId > 0 ? "people" : json["filterCategory"].stringValue
        
        for automaticAlertJSON in json["AutomaticAlert"].arrayValue {
            automaticAlerts.append(INBuildingAutomaticAlert(json: automaticAlertJSON))
        }
        
        self.createdAt = DateFormatter.isoDateFormatter.date(from: json["created"].stringValue)
    }
    
    static func initMany(json: JSON, currentSubscriberId: Int, isSubscribed: Bool, managedBuildingIds: [Int]) -> [INBuilding] {
        var buildings: [INBuilding] = []
        for bJSON in json.arrayValue {
            if let building = INBuilding(json: bJSON, currentSubscriberId: currentSubscriberId, isSubscribed: isSubscribed, managedBuildingIds: managedBuildingIds) {
                buildings.append(building)
            }
        }
        return buildings
    }

}

extension INBuilding {
    
    public var image: UIImage? {
        return HeroImage.buildingImage(id)
    }
    
    public var availableSubscriptions: [Subscription] {
        if isVirtual {
            return [.always, .never]
        } else {
            return Subscription.allCases
        }
    }
    
    public var availableNotificationTypes: [NotificationType] {
        if isPersonal {
            return NotificationType.pcSendable
        } else {
            let canSendLSA = INSubscriber.current?.canSendLSA ?? false
            return NotificationType.regularSendable(canSendLSA: canSendLSA)
        }
    }
    
    public var isCallable: Bool {
        return !isVirtual && isVoipEnabled
    }
    
    public var availableContactActions: [ContactAction] {
        var actions: [ContactAction] = []
        if isManagedByCurrentUser {
            actions.append(.message)
        } else {
            if isCallable {
                actions.append(.call)
            }
            if isTextEnabled {
                actions.append(.suggest)
            }
        }
        return actions
    }
    
    public var action: Action? {
        if isManagedByCurrentUser {
            return nil
        } else {
            return isSubscribedByCurrentUser ? .disconnect : .connect
        }
    }
    
    public var filterCategory: BuildingFilterCategory? {
        return BuildingFilterCategory(rawValue: _filterCategory)
    }
}
