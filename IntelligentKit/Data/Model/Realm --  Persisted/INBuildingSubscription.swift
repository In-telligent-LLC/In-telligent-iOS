//
//  BuildingsSubscriber.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/30/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

public class INBuildingSubscription: Object {
    
    override static public func primaryKey() -> String? {
        return "buildingId"
    }
    
    @objc dynamic public var buildingId: Int = 0

    @objc dynamic private var _alertsSubscription: String = ""
    @objc dynamic private var _offersSubscription: String = ""
    @objc dynamic public var automatic: Bool = false

    convenience init?(buildingId: Int, json: JSON) {
        guard !json.isEmpty else { return nil }
        
        self.init()
        
        self.buildingId = buildingId
        
        self._alertsSubscription = json["alertsSubscription"].stringValue
        self._offersSubscription = json["offersSubscription"].stringValue
        self.automatic = json["automatic"].boolValue
    }
    
}

extension INBuildingSubscription {
    public var alertsSubscription: Subscription? {
        get { return Subscription(rawValue: _alertsSubscription) }
        set { _alertsSubscription = newValue?.rawValue ?? "" }
    }
}
