//
//  BuildingAutomaticAlert.swift
//  Intelligent
//
//  Created by Kurt Jensen on 11/14/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

public class INBuildingAutomaticAlert: Object {
    
    override static public func primaryKey() -> String? {
        return "id"
    }
    
    @objc dynamic public var id: Int = 0
    @objc dynamic public var buildingId: Int = 0
    
    @objc dynamic public var name: String = ""
    @objc dynamic public var info: String = ""
    
    @objc dynamic public var startTime: String = ""
    @objc dynamic public var endTime: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        buildingId = json["building_id"].intValue
        
        name = json["name"].stringValue
        info = json["description"].stringValue
        
        startTime = json["start_time"].stringValue
        endTime = json["end_time"].stringValue
    }
    
}
