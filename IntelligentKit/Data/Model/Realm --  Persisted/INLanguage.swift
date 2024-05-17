//
//  Language.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/5/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

public class Language: Object {
    
    override static public func primaryKey() -> String? {
        return "code"
    }
    
    @objc dynamic public var code: String = ""
    @objc dynamic public var name: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        code = json["language"].stringValue
        name = json["name"].stringValue
    }
    
}
