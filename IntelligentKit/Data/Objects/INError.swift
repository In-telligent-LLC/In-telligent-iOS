//
//  INError.swift
//  Intelligent
//
//  Created by Kurt on 9/28/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation
import SwiftyJSON

public class INError: NSError {
    
    public var inputViews: [UIView] {
        // TODO inputViews
        return userInfo["inputViews"] as? [UIView] ?? []
    }
    
    convenience public init(message: String?, inputViews: [UIView] = []) {
        let message = message ?? "An unkown error occurred."
        self.init(domain: Bundle.main.bundleIdentifier!, code: -1, userInfo: [NSLocalizedDescriptionKey: message, "inputViews": inputViews])
    }
    
    convenience public init(json: JSON, inputViews: [UIView] = []) {
        let message = json["error"].string ?? json["errors"]["name"].array?.first?.stringValue ?? "An unkown error occurred."
        self.init(message: message, inputViews: inputViews)
    }

}
