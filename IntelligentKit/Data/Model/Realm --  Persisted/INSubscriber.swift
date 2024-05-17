//
//  Subscriber.swift
//  Intelligent
//
//  Created by Kurt on 10/4/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

public class INSubscriber: Object {
    
    static let CURRENT = "CURRENT"
    
    class public var current: INSubscriber? {
        return INSubscriber.object(forPrimaryKey: CURRENT)
    }
    
    override static public func primaryKey() -> String? {
        return "_id"
    }
    
    @objc dynamic public var _id: String = CURRENT
    @objc dynamic public var id: Int = 0
    
    @objc dynamic public var name: String!
    @objc dynamic public var email: String!
    @objc dynamic public var zipcode: String!
    @objc dynamic public var language: String?

    @objc dynamic public var isWeatherEnabled: Bool = false
    @objc dynamic public var isLightningEnabled: Bool = false
    @objc dynamic public var isLightningConfirmed: Bool = false
    @objc dynamic public var canSendLSA: Bool = false

    @objc dynamic private var _age: Int = 0
    @objc dynamic private var _gender: String!
    
    public var myBuildings = List<INBuilding>()
    public var autoSubscribeOptOutBuildingIds = List<Int>()

    public var age: Age {
        get { return Age(rawValue: _age) ?? .unspecified }
        set { _age = newValue.rawValue }
    }
    public var gender: Gender {
        get { return Gender(rawValue: _gender) ?? .unspecified }
        set { _gender = newValue.rawValue }
    }
    
    public var languageName: String? {
        guard let language = language else { return nil }
        return (Locale.current as NSLocale).displayName(forKey: .identifier, value: language)
    }
    
    public func isSubscribed(to buildingId: Int) -> Bool {
        let isSubscribed = myBuildings.first(where: { return $0.id == buildingId }) != nil
        return isSubscribed
    }
    
    public func isAutoSubscribed(to buildingId: Int) -> Bool {
        let isAutoSubscribed = myBuildings.first(where: { return $0.id == buildingId })?.subscriber?.automatic ?? false
        return isAutoSubscribed
    }
    
    convenience init?(json: JSON) {
        guard let id = json["id"].int else { return nil }
        
        self.init()
        
        self.id = id
        
        name = json["name"].stringValue
        email = json["email"].stringValue
        zipcode = json["zipcode"].stringValue
        language = json["language"].stringValue

        isWeatherEnabled = json["weatherAlertEnabled"].boolValue
        isLightningEnabled = json["lightningAlertEnabled"].boolValue
        isLightningConfirmed = json["lightningAlertConfirmed"].boolValue
        
        canSendLSA = json["User"]["canSendLSA"].boolValue

        gender = Gender(rawValue: json["gender"].stringValue) ?? .unspecified
        age = Age(rawValue: json["age"].intValue) ?? .unspecified
        
        var managedBuildingIds: [Int] = []
        for bJSON in json["User"]["Buildings"].arrayValue {
            managedBuildingIds.append(bJSON["id"].intValue)
        }
        
        var myBuildingsDict: [Int: INBuilding] = [:]
        for building in INBuilding.initMany(json: json["PersonalCommunity"], currentSubscriberId: id, isSubscribed: true, managedBuildingIds: managedBuildingIds) {
            myBuildingsDict[building.id] = building
        }
        for building in INBuilding.initMany(json: json["Buildings"], currentSubscriberId: id, isSubscribed: true, managedBuildingIds: managedBuildingIds) {
            myBuildingsDict[building.id] = building
        }
        
        let myBuildings = List<INBuilding>()
        for building in myBuildingsDict.values {
            myBuildings.append(building)
        }
        self.myBuildings = myBuildings

        for bJSON in json["SubscriberAutoSubscribeOptOuts"].arrayValue {
            if let id = bJSON["buildingId"].int {
                autoSubscribeOptOutBuildingIds.append(id)
            }
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

extension INSubscriber {
    func getSubscribedBuilding(_ buildingId: Int) -> INBuilding? {
        return myBuildings.first(where: { return $0.id == buildingId })
    }
}

