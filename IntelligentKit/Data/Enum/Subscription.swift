//
//  Subscription.swift
//  Intelligent
//
//  Created by Kurt Jensen on 10/30/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

public enum Subscription: String, CaseIterable {
    case always = "a",
    inBuilding = "i",
    never = "n"
    
    public var localizedString: String {
        switch self {
        case .always: return NSLocalizedString("Always", comment: "")
        case .inBuilding: return NSLocalizedString("Only When I'm Here", comment: "")
        case .never: return NSLocalizedString("Never", comment: "")
        }
    }
}
