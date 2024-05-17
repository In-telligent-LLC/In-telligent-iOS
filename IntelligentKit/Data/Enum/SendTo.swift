//
//  SendTo.swift
//  Intelligent
//
//  Created by Kurt on 11/13/18.
//  Copyright © 2018 Kurt Jensen. All rights reserved.
//

import Foundation

public enum SendTo: String, CaseIterable {
    case all = "a",
    specificSubscribers = "s"
    
    public var localizedString: String {
        switch self {
        case .all: return NSLocalizedString("All Subscribers", comment: "")
        case .specificSubscribers: return NSLocalizedString("Specific Subscribers", comment: "")
        }
    }
}

